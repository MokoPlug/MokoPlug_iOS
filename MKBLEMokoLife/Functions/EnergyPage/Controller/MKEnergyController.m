//
//  MKEnergyController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKEnergyController.h"

#import "MKEnergyDailyTableView.h"
#import "MKEnergyMonthlyTableView.h"

#import "MKDeviceInfoController.h"

#import "MKEnergyDataModel.h"

@interface MKEnergyController ()

@property (nonatomic, strong)UIView *segment;

@property (nonatomic, strong)UIButton *dailyButton;

@property (nonatomic, strong)UIButton *monthlyButton;

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)MKEnergyMonthlyTableView *monthTable;

@property (nonatomic, strong)MKEnergyDailyTableView *dailyTable;

@property (nonatomic, strong)MKEnergyDataModel *dataModel;

@end

@implementation MKEnergyController

- (void)dealloc {
    NSLog(@"MKEnergyController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDeviceName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readEnergyDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    MKDeviceInfoController *vc = [[MKDeviceInfoController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - event emthod
- (void)dailyButtonPressed {
    if (self.selectedIndex == 0) {
        return;
    }
    self.selectedIndex = 0;
    [self reloadSubViews];
}

- (void)monthlyButtonPressed {
    if (self.selectedIndex == 1) {
        return;
    }
    self.selectedIndex = 1;
    [self reloadSubViews];
}

#pragma mark - read data
- (void)readEnergyDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel startReadEnergyDatasWithScuBlock:^(NSArray * _Nonnull dailyList, NSArray * _Nonnull monthlyList, NSString * _Nonnull pulseConstant) {
        [[MKHudManager share] hide];
        __strong typeof(self) sself = weakSelf;
        [sself.dailyTable updateEnergyDatas:dailyList pulseConstant:pulseConstant];
        [sself.monthTable updateEnergyDatas:monthlyList pulseConstant:pulseConstant];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        __strong typeof(self) sself = weakSelf;
        [sself.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readDeviceName {
    [MKLifeBLEInterface readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        self.defaultTitle = returnData[@"result"][@"deviceName"];
    } failedBlock:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - private method
- (void)reloadSubViews {
    UIColor *dailyTitleColor = (self.selectedIndex == 0 ? COLOR_WHITE_MACROS : COLOR_NAVIBAR_CUSTOM);
    UIColor *monthlyTitleColor = (self.selectedIndex == 1 ? COLOR_WHITE_MACROS : COLOR_NAVIBAR_CUSTOM);
    UIColor *dailyBackColor = (self.selectedIndex == 0 ? COLOR_NAVIBAR_CUSTOM : COLOR_WHITE_MACROS);
    UIColor *monthlyBackColor = (self.selectedIndex == 1 ? COLOR_NAVIBAR_CUSTOM : COLOR_WHITE_MACROS);
    [self.dailyButton setTitleColor:dailyTitleColor forState:UIControlStateNormal];
    [self.dailyButton setBackgroundColor:dailyBackColor];
    [self.monthlyButton setTitleColor:monthlyTitleColor forState:UIControlStateNormal];
    [self.monthlyButton setBackgroundColor:monthlyBackColor];
    self.dailyTable.hidden = !(self.selectedIndex == 0);
    self.monthTable.hidden = !(self.selectedIndex == 1);
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(240);
        make.top.mas_equalTo(defaultTopInset + 10.f);
        make.height.mas_equalTo(32.f);
    }];
    [self.segment addSubview:self.dailyButton];
    [self.dailyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.segment.mas_centerX);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.segment addSubview:self.monthlyButton];
    [self.monthlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.segment.mas_centerX);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.view addSubview:self.monthTable];
    [self.view addSubview:self.dailyTable];
    [self.monthTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.segment.mas_bottom);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
    [self.dailyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.monthTable);
    }];
}

#pragma mark - getter
- (UIView *)segment {
    if (!_segment) {
        _segment = [[UIView alloc] init];
        _segment.layer.masksToBounds = YES;
        _segment.layer.borderColor = COLOR_NAVIBAR_CUSTOM.CGColor;
        _segment.layer.borderWidth = 0.5f;
        _segment.layer.cornerRadius = 16.f;
    }
    return _segment;
}

- (UIButton *)dailyButton {
    if (!_dailyButton) {
        _dailyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dailyButton.backgroundColor = COLOR_NAVIBAR_CUSTOM;
        _dailyButton.titleLabel.font = MKFont(14.f);
        [_dailyButton setTitle:@"Daily" forState:UIControlStateNormal];
        [_dailyButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_dailyButton addTarget:self
                         action:@selector(dailyButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _dailyButton;
}

- (MKEnergyDailyTableView *)dailyTable {
    if (!_dailyTable) {
        _dailyTable = [[MKEnergyDailyTableView alloc] init];
    }
    return _dailyTable;
}

- (UIButton *)monthlyButton {
    if (!_monthlyButton) {
        _monthlyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _monthlyButton.backgroundColor = COLOR_WHITE_MACROS;
        _monthlyButton.titleLabel.font = MKFont(14.f);
        [_monthlyButton setTitle:@"Monthly" forState:UIControlStateNormal];
        [_monthlyButton setTitleColor:COLOR_NAVIBAR_CUSTOM forState:UIControlStateNormal];
        [_monthlyButton addTarget:self
                           action:@selector(monthlyButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthlyButton;
}

- (MKEnergyMonthlyTableView *)monthTable {
    if (!_monthTable) {
        _monthTable = [[MKEnergyMonthlyTableView alloc] init];
    }
    return _monthTable;
}

- (MKEnergyDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKEnergyDataModel alloc] init];
    }
    return _dataModel;
}

@end
