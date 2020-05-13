//
//  MKDeviceInfoController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKDeviceInfoController.h"

#import "MKContactTrackerTextCell.h"

@interface MKDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKDeviceInfoController

- (void)dealloc {
    NSLog(@"MKDeviceInfoController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
    [self startReadDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKContactTrackerTextCell *cell = [MKContactTrackerTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - Interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    dispatch_async(self.readQueue, ^{
        NSString *deviceName = [self readDeviceName];
        if (!deviceName) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read device name error"];
            });
            return ;
        }
        NSString *firmware = [self readFirmware];
        if (!firmware) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read firmware error"];
            });
            return ;
        }
        NSString *macAddress = [self readMacAddress];
        if (!macAddress) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read macAddress error"];
            });
            return ;
        }
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            self.defaultTitle = deviceName;
            MKContactTrackerTextCellModel *productModel = self.dataList[1];
            productModel.rightMsg = deviceName;
            MKContactTrackerTextCellModel *firmwareModel = self.dataList[2];
            firmwareModel.rightMsg = firmware;
            MKContactTrackerTextCellModel *macModel = self.dataList[3];
            macModel.rightMsg = macAddress;
            [self.tableView reloadData];
        })
    });
}

- (NSString *)readDeviceName {
    __block NSString *deviceName = nil;
    [MKLifeBLEInterface readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        deviceName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return deviceName;
}

- (NSString *)readFirmware {
    __block NSString *firmware = nil;
    [MKLifeBLEInterface readFirmwareVersionWithSucBlock:^(id  _Nonnull returnData) {
        firmware = returnData[@"result"][@"firmware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return firmware;
}

- (NSString *)readMacAddress {
    __block NSString *macAddress = nil;
    [MKLifeBLEInterface readMacAddressWithSucBlock:^(id  _Nonnull returnData) {
        macAddress = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return macAddress;
}

#pragma mark - UI
- (void)loadTableDatas {
    MKContactTrackerTextCellModel *companyModel = [[MKContactTrackerTextCellModel alloc] init];
    companyModel.leftMsg = @"Company Name";
    companyModel.rightMsg = @"MOKO TECHNOLOGY LTD.";
    [self.dataList addObject:companyModel];
    
    MKContactTrackerTextCellModel *productModel = [[MKContactTrackerTextCellModel alloc] init];
    productModel.leftMsg = @"Product Name";
    [self.dataList addObject:productModel];
    
    MKContactTrackerTextCellModel *firmwareModel = [[MKContactTrackerTextCellModel alloc] init];
    firmwareModel.leftMsg = @"Firmware Version";
    [self.dataList addObject:firmwareModel];
    
    MKContactTrackerTextCellModel *macModel = [[MKContactTrackerTextCellModel alloc] init];
    macModel.leftMsg = @"Device Mac";
    [self.dataList addObject:macModel];
    
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setHidden:YES];
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("readParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
