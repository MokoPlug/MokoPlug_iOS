//
//  MKScanPageController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/5.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKScanPageController.h"
#import "MKScanSearchButton.h"
#import "MKScanSearchView.h"
#import "MKLifeBLEDeviceModel+MKScanPage.h"
#import "MKScanPageCell.h"

#import "MKAboutController.h"

static CGFloat const offset_X = 15.f;
static CGFloat const searchButtonHeight = 40.f;

static NSString *const MKLeftButtonAnimationKey = @"MKLeftButtonAnimationKey";

@interface MKSortModel : NSObject

/**
 过滤条件，mac或者名字包含的搜索条件
 */
@property (nonatomic, copy)NSString *searchName;

/**
 过滤设备的rssi
 */
@property (nonatomic, assign)NSInteger sortRssi;

/**
 是否打开了搜索条件
 */
@property (nonatomic, assign)BOOL isOpen;

@end

@implementation MKSortModel

@end

@interface MKScanPageController ()<UITableViewDelegate,UITableViewDataSource,MKLifeBLECentralManagerDelegate>

@property (nonatomic, strong)UIImageView *circleIcon;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKScanSearchButton *searchButton;

@property (nonatomic, strong)MKSortModel *sortModel;

/**
 数据源
 */
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UITextField *passwordField;

/**
 当从配置页面返回的时候，需要扫描
 */
@property (nonatomic, assign)BOOL needScan;

@property (nonatomic, strong)dispatch_source_t scanTimer;

@property (nonatomic, strong)dispatch_queue_t scanQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

/// 当左侧按钮停止扫描的时候,currentScanStatus = NO,开始扫描的时候currentScanStatus=YES
@property (nonatomic, assign)BOOL currentScanStatus;

@end

@implementation MKScanPageController

- (void)dealloc {
    NSLog(@"MKScanPageController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needScan && [MKLifeBLECentralManager shared].centralStatus == MKCentralManagerStateEnable) {
        self.needScan = NO;
        self.leftButton.selected = NO;
        self.currentScanStatus = NO;
        [self leftButtonMethod];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCentralScanDelegate)
                                                 name:@"MKCentralDeallocNotification"
                                               object:nil];
    [self setCentralScanDelegate];
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:3.5f];
}

#pragma mark - super method

- (void)leftButtonMethod {
    if ([MKLifeBLECentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.leftButton.selected = !self.leftButton.selected;
    self.currentScanStatus = self.leftButton.selected;
    if (!self.leftButton.isSelected) {
        //停止扫描
        [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
        [[MKLifeBLECentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    [self addAnimationForLeftButton];
    [self scanTimerRun];
}

- (void)rightButtonMethod {
    MKAboutController *vc = [[MKAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKLifeBLEDeviceModel *deviceModel = self.dataList[indexPath.row];
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKLifeBLECentralManager shared] connectPeripheral:deviceModel.peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MKNeedResetRootControllerToTabBar" object:nil userInfo:@{}];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKScanPageCell *cell = [MKScanPageCell initCellWithTableView:self.tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - MKLifeBLECentralManagerDelegate
- (void)mokoLifeBleScanNewDevice:(MKLifeBLEDeviceModel *)deviceModel {
    dispatch_async(self.scanQueue, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (!self.currentScanStatus) {
            //停止扫描了
            [self unlock];
            return ;
        }
        [self updateDataWithModel:deviceModel];
        moko_dispatch_main_safe(^{
            [self performSelector:@selector(unlock) afterDelay:.1f];
        });
    });
}

- (void)mokoLifeBleStopScan {
    //如果是左上角在动画，则停止动画
    if (self.leftButton.isSelected) {
        [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
        [self.leftButton setSelected:NO];
    }
}

#pragma mark - MKScanPageCellDelegate
- (void)scanCellConnectButtonPressed:(NSInteger)index {
    if (index >= self.dataList.count) {
        return;
    }
//    [self connectDeviceWithModel:self.dataList[index]];
}

#pragma mark - notice method
- (void)setCentralScanDelegate{
    [MKLifeBLECentralManager shared].delegate = self;
}

#pragma mark - private method

- (void)unlock {
    dispatch_semaphore_signal(self.semaphore);
}

- (void)showCentralStatus{
    if (kSystemVersion >= 11.0 && [MKLifeBLECentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        //对于iOS11以上的系统，打开app的时候，如果蓝牙未打开，弹窗提示，后面系统蓝牙状态再发生改变就不需要弹窗了
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [kAppRootController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self leftButtonMethod];
}

#pragma mark - 扫描部分
/**
 搜索设备
 */
- (void)serachButtonPressed{
    MKScanSearchView *searchView = [[MKScanSearchView alloc] init];
    WS(weakSelf);
    searchView.scanSearchViewDismisBlock = ^(BOOL update, NSString *text, CGFloat rssi) {
        if (!update) {
            return ;
        }
        weakSelf.sortModel.sortRssi = (NSInteger)rssi;
        weakSelf.sortModel.searchName = text;
        weakSelf.sortModel.isOpen = YES;
        weakSelf.searchButton.searchConditions = (ValidStr(weakSelf.sortModel.searchName) ?
                                                  [@[weakSelf.sortModel.searchName,[NSString stringWithFormat:@"%@dBm",[NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi]]] mutableCopy] :
                                                  [@[[NSString stringWithFormat:@"%@dBm",[NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi]]] mutableCopy]);
        weakSelf.leftButton.selected = NO;
        weakSelf.currentScanStatus = NO;
        [weakSelf leftButtonMethod];
    };
    [searchView showWithText:(self.sortModel.isOpen ? self.sortModel.searchName : @"")
                   rssiValue:(self.sortModel.isOpen ? [NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi] : @"")];
}

- (void)updateDataWithModel:(MKLifeBLEDeviceModel *)deviceModel{
    if (self.sortModel.isOpen) {
        if (!ValidStr(self.sortModel.searchName)) {
            //打开了过滤，但是只过滤rssi
            [self filterPlugDataWithRssi:deviceModel];
            return;
        }
        //如果打开了过滤，先看是否需要过滤设备名字和mac地址
        [self filterPlugDataWithSearchName:deviceModel];
        return;
    }
    [self processPlugData:deviceModel];
}

/**
 通过rssi过滤设备
 */
- (void)filterPlugDataWithRssi:(MKLifeBLEDeviceModel *)deviceModel{
    if (deviceModel.rssi < self.sortModel.sortRssi) {
        return;
    }
    [self processPlugData:deviceModel];
}

/**
 通过设备名称和mac地址过滤设备，这个时候肯定开启了rssi

 @param deviceModel 设备
 */
- (void)filterPlugDataWithSearchName:(MKLifeBLEDeviceModel *)deviceModel{
    if (deviceModel.rssi < self.sortModel.sortRssi) {
        return;
    }
    if ([[deviceModel.deviceName uppercaseString] containsString:[self.sortModel.searchName uppercaseString]]) {
        //如果设备名称包含搜索条件，则加入
        [self processPlugData:deviceModel];
    }
}

- (void)processPlugData:(MKLifeBLEDeviceModel *)deviceModel{
    //查看数据源中是否已经存在相关设备
    NSString *identy = deviceModel.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，替换
        [self dataExistDataSource:deviceModel];
        return;
    }
    //不存在，则加入
    [self dataNoExistDataSource:deviceModel];
}

/**
 将扫描到的设备加入到数据源

 @param deviceModel 扫描到的设备
 */
- (void)dataNoExistDataSource:(MKLifeBLEDeviceModel *)deviceModel{
    moko_dispatch_main_safe(^{
        [self.dataList addObject:deviceModel];
        deviceModel.index = (self.dataList.count - 1);
        deviceModel.identifier = deviceModel.peripheral.identifier.UUIDString;
        [UIView performWithoutAnimation:^{
            [self.tableView insertRow:(self.dataList.count - 1) inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
    });
}

/**
 如果是已经存在了，直接替换

 @param deviceModel  新扫描到的数据帧
 */
- (void)dataExistDataSource:(MKLifeBLEDeviceModel *)deviceModel {
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKLifeBLEDeviceModel *dataModel = self.dataList[i];
        if ([dataModel.peripheral.identifier.UUIDString isEqualToString:deviceModel.peripheral.identifier.UUIDString]) {
            currentIndex = i;
            break;
        }
    }
    deviceModel.index = currentIndex;
    [self.dataList replaceObjectAtIndex:currentIndex withObject:deviceModel];
    moko_dispatch_main_safe(^{
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRow:currentIndex inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
    });
}



- (void)connectFailed {
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

- (void)addAnimationForLeftButton{
    [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
    [self.circleIcon.layer addAnimation:[self animation] forKey:MKLeftButtonAnimationKey];
}

- (CABasicAnimation *)animation{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = 2.f;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

#pragma mark - 扫描监听
- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKLifeBLECentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        [[MKLifeBLECentralManager shared] stopScan];
    });
    dispatch_resume(self.scanTimer);
}

#pragma mark - UI

- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"Bluetooth Plug";
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton addSubview:self.circleIcon];
    [self.circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self.rightButton setImage:LOADIMAGE(@"scanRightAboutIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(245, 245, 245)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  kScreenWidth - 2 * offset_X,
                                                                  searchButtonHeight + 2 * offset_X)];
    [headerView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(offset_X);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(searchButtonHeight + 2 * offset_X);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(headerView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 5.f);
    }];
}

#pragma mark - getter
- (MKScanSearchButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[MKScanSearchButton alloc] init];
        [_searchButton setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [_searchButton.layer setMasksToBounds:YES];
        [_searchButton.layer setCornerRadius:16.f];
        [_searchButton.layer setBorderColor:CUTTING_LINE_COLOR.CGColor];
        [_searchButton.layer setBorderWidth:0.5f];
        _searchButton.searchConditions = [@[] mutableCopy];
        WS(weakSelf);
        _searchButton.clearSearchConditionsBlock = ^{
            weakSelf.sortModel.isOpen = NO;
            weakSelf.sortModel.searchName = @"";
            weakSelf.sortModel.sortRssi = -127;
            weakSelf.leftButton.selected = NO;
            weakSelf.currentScanStatus = NO;
            [weakSelf leftButtonMethod];
        };
        _searchButton.searchButtonPressedBlock = ^{
            [weakSelf serachButtonPressed];
        };
    }
    return _searchButton;
}

- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(245, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)circleIcon{
    if (!_circleIcon) {
        _circleIcon = [[UIImageView alloc] init];
        _circleIcon.image = LOADIMAGE(@"scanRefresh", @"png");
    }
    return _circleIcon;
}

- (MKSortModel *)sortModel{
    if (!_sortModel) {
        _sortModel = [[MKSortModel alloc] init];
    }
    return _sortModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (dispatch_queue_t)scanQueue {
    if (!_scanQueue) {
        _scanQueue = dispatch_queue_create("com.moko.readScanConfigQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _scanQueue;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

@end
