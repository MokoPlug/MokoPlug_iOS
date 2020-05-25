//
//  MKPowerController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKPowerController.h"
#import "MKPowerCircleView.h"

#import "MKDeviceInfoController.h"

static CGFloat const circleView_offset_X = 30.f;
static CGFloat const buttonWidth = 120.f;
static CGFloat const buttonHeight = 32.f;

@interface MKPowerController ()

@property (nonatomic, strong)MKPowerCircleView *circleView;

@property (nonatomic, strong)UIButton *statusButton;

@property (nonatomic, strong)UILabel *overLoadLabel;

/// 是否过载
@property (nonatomic, assign)BOOL overLoad;

/// 当前功率值
@property (nonatomic, assign)CGFloat energyPower;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKPowerController

- (void)dealloc {
    NSLog(@"MKPowerController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self addNotifications];
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

#pragma mark - event method
- (void)statusButtonPressed {
    BOOL isOn = self.statusButton.selected;
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configSwitchStatus:!isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.statusButton.selected = !isOn;
        [self reloadStatus];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)reloadStatus {
    self.overLoadLabel.hidden = !self.overLoad;
    if (self.overLoad) {
        //过载
        self.statusButton.enabled = NO;
        [self.statusButton setBackgroundColor:RGBCOLOR(217, 217, 217)];
        [self.statusButton setTitle:@"OFF" forState:UIControlStateNormal];
        [self.statusButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        return;
    }
    //正常状态
    NSString *buttonTitle = (self.statusButton.selected ? @"ON" : @"OFF");
    UIColor *backColor = (self.statusButton.selected ? COLOR_NAVIBAR_CUSTOM : COLOR_WHITE_MACROS);
    UIColor *titleColor = (self.statusButton.selected ? COLOR_WHITE_MACROS : COLOR_NAVIBAR_CUSTOM);
    [self.statusButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.statusButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.statusButton setBackgroundColor:backColor];
}

- (void)reloadPowerValue {
    [self.circleView updatePowerValues:self.energyPower];
}

#pragma mark - interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    dispatch_async(self.readQueue, ^{
        NSString *deviceName = [self readDeviceName];
        if (!deviceName) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read deviceName error"];
            });
            return ;
        }
        if (![self readSwitchStatus]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read switch status error"];
            });
            return ;
        }
        if (![self readOverLoadStatus]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read overload status error"];
            });
            return ;
        }
        if (![self readPowerDatas]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Read power error"];
            });
            return ;
        }
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            self.defaultTitle = deviceName;
            [self reloadStatus];
            [self reloadPowerValue];
        });
        
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

- (BOOL)readSwitchStatus {
    __block BOOL success = NO;
    [MKLifeBLEInterface readSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.statusButton.selected = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readOverLoadStatus {
    __block BOOL success = NO;
    [MKLifeBLEInterface readOverLoadStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.overLoad = [returnData[@"result"][@"isOverLoad"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPowerDatas {
    __block BOOL success = NO;
    [MKLifeBLEInterface readVCPValueWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.energyPower = [returnData[@"result"][@"p"] floatValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - notes
- (void)switchStatusChanged:(NSNotification *)note {
    self.statusButton.selected = [note.userInfo[@"isOn"] boolValue];
    [self reloadStatus];
}

- (void)overloadProtection:(NSNotification *)note {
    self.overLoad = YES;
    [self reloadStatus];
}

- (void)energyVCPNotification:(NSNotification *)note {
    self.energyPower = [note.userInfo[@"p"] floatValue];
    [self reloadPowerValue];
}

- (void)overloadStatusChanged:(NSNotification *)note {
    [self.view showCentralToast:@"LOAD INSERTION"];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchStatusChanged:)
                                                 name:mk_receiveSwitchStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(overloadProtection:)
                                                 name:mk_receiveOverloadProtectionValueChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(energyVCPNotification:)
                                                 name:mk_receiveEnergyVCPNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(overloadStatusChanged:)
                                                 name:mk_receiveLoadStatusChangedNotification
                                               object:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.statusButton];
    [self.view addSubview:self.overLoadLabel];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.circleView.mas_bottom).mas_offset(20.f);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.overLoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.statusButton.mas_bottom).mas_offset(16.f);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonHeight);
    }];
}

#pragma mark - getter
- (MKPowerCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[MKPowerCircleView alloc] initWithFrame:CGRectMake(circleView_offset_X, defaultTopInset + 60.f, kScreenWidth - 2 * circleView_offset_X, kScreenWidth - 2 * circleView_offset_X)];
    }
    return _circleView;
}

- (UIButton *)statusButton {
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.layer.masksToBounds = YES;
        _statusButton.layer.cornerRadius = 14.f;
        [_statusButton addTapAction:self selector:@selector(statusButtonPressed)];
    }
    return _statusButton;
}

- (UILabel *)overLoadLabel {
    if (!_overLoadLabel) {
        _overLoadLabel = [[UILabel alloc] init];
        _overLoadLabel.textColor = RGBCOLOR(120, 120, 120);
        _overLoadLabel.textAlignment = NSTextAlignmentCenter;
        _overLoadLabel.font = MKFont(15.f);
        _overLoadLabel.text = @"Overload";
    }
    return _overLoadLabel;
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
