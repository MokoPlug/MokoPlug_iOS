//
//  MKSettingController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKSettingController.h"

#import "MKSettingPageCell.h"
#import "MKSettingButtonCell.h"

#import "MKSettingPageCellModel.h"
#import "MKSettingDatasModel.h"

#import "MKDeviceInfoController.h"
#import "MKModifyPowerStatusController.h"
#import "MKModifyNormalDatasController.h"

@interface MKSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKSettingDatasModel *dataModel;

@end

@implementation MKSettingController

- (void)dealloc {
    NSLog(@"MKSettingController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDatasFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCurrentEnergyNotification:)
                                                 name:mk_receiveCurrentEnergyNotification
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    MKDeviceInfoController *vc = [[MKDeviceInfoController alloc] init];
    [self pushControllerWithHiddenBottom:vc];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MKModifyNormalDatasController *vc = [[MKModifyNormalDatasController alloc] init];
            vc.pageType = MKModifyDeviceNamePage;
            vc.textFieldValue = self.dataModel.deviceName;
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        if (indexPath.row == 1) {
            MKModifyPowerStatusController *vc = [[MKModifyPowerStatusController alloc] init];
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        return;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //广播间隔
            MKModifyNormalDatasController *vc = [[MKModifyNormalDatasController alloc] init];
            vc.pageType = MKModifyBroadcastFrequencyPage;
            vc.textFieldValue = self.dataModel.advInterval;
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        if (indexPath.row == 1) {
            //过载保护
            MKModifyNormalDatasController *vc = [[MKModifyNormalDatasController alloc] init];
            vc.pageType = MKModifyOverloadValuePage;
            vc.textFieldValue = self.dataModel.overloadValue;
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        if (indexPath.row == 2) {
            //电能存储间隔
            MKModifyNormalDatasController *vc = [[MKModifyNormalDatasController alloc] init];
            vc.pageType = MKModifyPowerReportIntervalPage;
            vc.textFieldValue = self.dataModel.powerReInterval;
            vc.powerValue = self.dataModel.powerChangeNoti;
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        if (indexPath.row == 3) {
            //电能变化值
            MKModifyNormalDatasController *vc = [[MKModifyNormalDatasController alloc] init];
            vc.pageType = MKModifyPowerChangeNotificationPage;
            vc.textFieldValue = self.dataModel.powerChangeNoti;
            vc.powerValue = self.dataModel.powerReInterval;
            [self pushControllerWithHiddenBottom:vc];
            return;
        }
        if (indexPath.row == 4) {
            //重置电能
            [self resetEnergyConsumptionAlert];
        }
        return;
    }
    if (indexPath.section == 2) {
        //恢复出厂设置
        [self resetDeviceAlert];
        return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    }
    if (section == 1) {
        return 50.f;
    }
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *section0Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.f)];
        section0Header.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (40.f - MKFont(12.f).lineHeight) / 2, kScreenWidth - 2 * 15.f, MKFont(12.f).lineHeight)];
        sectionLabel.textColor = RGBCOLOR(128, 128, 128);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = MKFont(12.f);
        sectionLabel.text = @"General settings";
        [section0Header addSubview:sectionLabel];
        
        return section0Header;
    }
    if (section == 1) {
        UIView *section1Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
        section1Header.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (50.f - MKFont(12.f).lineHeight) / 2, kScreenWidth - 2 * 15.f, MKFont(12.f).lineHeight)];
        sectionLabel.textColor = RGBCOLOR(128, 128, 128);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = MKFont(12.f);
        sectionLabel.text = @"Advanced settings";
        [section1Header addSubview:sectionLabel];
        
        return section1Header;
    }
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.f)];
    sectionHeader.backgroundColor = RGBCOLOR(242, 242, 242);
    return sectionHeader;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        MKSettingButtonCell *cell = [MKSettingButtonCell initCellWithTableView:tableView];
        cell.msg = self.section2List[indexPath.row];
        return cell;
    }
    MKSettingPageCell *cell = [MKSettingPageCell initCellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.dataModel = self.section0List[indexPath.row];
    }else {
        cell.dataModel = self.section1List[indexPath.row];
    }
    return cell;
}

#pragma mark - note
- (void)receiveCurrentEnergyNotification:(NSNotification *)note {
    float tempValue = [note.userInfo[@"totalValue"] floatValue] / [self.dataModel.pulseConstant floatValue];
    MKSettingPageCellModel *energyModel = self.section1List[4];
    energyModel.valueMsg = [NSString stringWithFormat:@"%.2f",tempValue];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadDatasFromDeviceWithSucBlock:^{
        [[MKHudManager share] hide];
        __strong typeof(self) sself = weakSelf;
        [sself reloadTableDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        __strong typeof(self) sself = weakSelf;
        [sself.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)resetEnergyConsumptionMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface resetAccumulatedEnergyWithSucBlock:^{
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAccumulatedEnergyNotification"
                                                            object:nil];
        [self readDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)resetDeviceMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface resetFactoryWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark -
- (void)resetEnergyConsumptionAlert {
    NSString *msg = @"Please confirm again whether to reset the accumulated electricity?Value will be recounted after clearing.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Energy Consumption"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf resetEnergyConsumptionMethod];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)resetDeviceAlert {
    NSString *msg = @"After reset,the relevant data will be totally cleared,please confirm again.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Device"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf resetDeviceMethod];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - private method
- (void)reloadTableDatas {
    self.defaultTitle = self.dataModel.deviceName;
    MKSettingPageCellModel *nameModel = self.section0List[0];
    nameModel.valueMsg = self.dataModel.deviceName;
    
    MKSettingPageCellModel *broadcastModel = self.section1List[0];
    broadcastModel.valueMsg = self.dataModel.advInterval;
    
    MKSettingPageCellModel *overloadValueModel = self.section1List[1];
    overloadValueModel.valueMsg = self.dataModel.overloadValue;
    
    MKSettingPageCellModel *reportIntervalModel = self.section1List[2];
    reportIntervalModel.valueMsg = self.dataModel.powerReInterval;
    
    MKSettingPageCellModel *notificationModel = self.section1List[3];
    notificationModel.valueMsg = self.dataModel.powerChangeNoti;
    
    MKSettingPageCellModel *energyModel = self.section1List[4];
    energyModel.valueMsg = self.dataModel.energyConsumption;
    
    [self.tableView reloadData];
}

- (void)pushControllerWithHiddenBottom:(UIViewController *)vc {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UI
- (void)loadTableDatas {
#pragma mark - section0数据源
    MKSettingPageCellModel *nameModel = [[MKSettingPageCellModel alloc] init];
    nameModel.leftMsg = @"Modify device name";
    [self.section0List addObject:nameModel];
    
    MKSettingPageCellModel *powerModel = [[MKSettingPageCellModel alloc] init];
    powerModel.leftMsg = @"Modify power on status";
    [self.section0List addObject:powerModel];
    
    MKSettingPageCellModel *updateModel = [[MKSettingPageCellModel alloc] init];
    updateModel.leftMsg = @"Check update";
    [self.section0List addObject:updateModel];
    
#pragma mark - section1数据源
    MKSettingPageCellModel *broadcastModel = [[MKSettingPageCellModel alloc] init];
    broadcastModel.leftMsg = @"Broadcast frequency(100ms)";
    [self.section1List addObject:broadcastModel];
    
    MKSettingPageCellModel *overloadValueModel = [[MKSettingPageCellModel alloc] init];
    overloadValueModel.leftMsg = @"Overload value(W)";
    [self.section1List addObject:overloadValueModel];
    
    MKSettingPageCellModel *reportIntervalModel = [[MKSettingPageCellModel alloc] init];
    reportIntervalModel.leftMsg = @"Power reporting Interval(min)";
    [self.section1List addObject:reportIntervalModel];
    
    MKSettingPageCellModel *notificationModel = [[MKSettingPageCellModel alloc] init];
    notificationModel.leftMsg = @"Power change notification(%)";
    [self.section1List addObject:notificationModel];
    
    MKSettingPageCellModel *energyModel = [[MKSettingPageCellModel alloc] init];
    energyModel.leftMsg = @"Energy consumption(KWh)";
    [self.section1List addObject:energyModel];
    
    [self.section2List addObject:@"Reset Device"];
//    [self.section2List addObject:@"Disconnect"];
    
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (MKSettingDatasModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKSettingDatasModel alloc] init];
    }
    return _dataModel;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    return footerView;
}

@end
