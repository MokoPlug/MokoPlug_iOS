//
//  MKTimerController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTimerController.h"

#import "MKTimerCircleView.h"
#import "MKConfigDeviceTimePickerView.h"

#import "MKDeviceInfoController.h"

static CGFloat const circleView_offset_X = 40.f;
static CGFloat const buttonWidth = 120.f;
static CGFloat const buttonHeight = 32.f;

@interface MKTimerController ()

@property (nonatomic, strong)MKTimerCircleView *circleView;

@property (nonatomic, strong)UIButton *timerButton;

@property (nonatomic, strong)UILabel *stateLabel;

@property (nonatomic, strong)UIImageView *haloRingView;

@property (nonatomic, strong)UILabel *timerLabel;

@end

@implementation MKTimerController

- (void)dealloc {
    NSLog(@"MKTimerController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDeviceName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCountdownTimerData:)
                                                 name:mk_receiveCountdownNotification
                                               object:nil];
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

#pragma mark - Notification
- (void)receiveCountdownTimerData:(NSNotification *)note {
    /*
     note: @{
@"isOn":@(isOn),//此处的isOn跟读取回来的倒计时状态不一样，这个isOn是倒计时结束之后开关的状态，读取回来的倒计时里面的isOn是指当前倒计时有没有打开
@"configValue":configValue,
@"remainingTime":remainingTime,
     };
     */
    NSString *state = ([note.userInfo[@"isOn"] boolValue] ? @"ON" : @"OFF");
    self.stateLabel.text = [state stringByAppendingString:@" after countdown"];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:@(YES) forKey:@"isOn"];
    [dataDic setObject:note.userInfo[@"configValue"] forKey:@"configValue"];
    [dataDic setObject:note.userInfo[@"remainingTime"] forKey:@"remainingTime"];
    [self reloadCircles:dataDic];
}

#pragma mark - event method
- (void)timerButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface readSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self showPickViewWithSwitchStatus:[returnData[@"result"][@"isOn"] boolValue]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - interface
- (void)readDeviceName {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        self.defaultTitle = returnData[@"result"][@"deviceName"];
        [self readDataFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readDataFromDevice {
    [MKLifeBLEInterface readCountdownValueWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self reloadCircles:returnData[@"result"]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configCountdownValue:(long long)seconds {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configCountdownValue:seconds sucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)reloadCircles:(NSDictionary *)returnData {
    BOOL isOn = [returnData[@"isOn"] boolValue];
    if (!isOn) {
        //倒计时未打开
        self.stateLabel.hidden = YES;
        self.timerLabel.text = @"Timer";
        [self.circleView updateProgress:0];
        return;
    }
    //倒计时打开
    self.stateLabel.hidden = NO;
    self.timerLabel.text = [self getTimeWithSec:returnData[@"remainingTime"]];
    if ([returnData[@"remainingTime"] floatValue] == 0) {
        //倒计时结束
        self.stateLabel.hidden = YES;
    }
    float progress = (1 - [returnData[@"remainingTime"] floatValue] / [returnData[@"configValue"] floatValue]);
    [self.circleView updateProgress:progress];
}

- (void)showPickViewWithSwitchStatus:(BOOL)isOn {
    MKConfigDeviceTimePickerView *pickView = [[MKConfigDeviceTimePickerView alloc] init];
    MKConfigDeviceTimeModel *timeModel = [[MKConfigDeviceTimeModel alloc] init];
    timeModel.hour = @"0";
    timeModel.minutes = @"0";
    timeModel.titleMsg = (isOn ? @"Countdown timer(off)" : @"Countdown timer(on)");
    pickView.timeModel = timeModel;
    [pickView showTimePickViewBlock:^(MKConfigDeviceTimeModel *timeModel) {
        NSInteger seconds = ([timeModel.hour integerValue] * 60 * 60) + [timeModel.minutes integerValue] * 60;
        [self configCountdownValue:seconds];
    }];
}

- (NSString *)getTimeWithSec:(NSString *)second{
    NSInteger minutes = floor([second integerValue] / 60);
    NSInteger sec = trunc([second integerValue] - minutes * 60);
    NSInteger hours1 = floor([second integerValue] / (60 * 60));
    minutes = minutes - hours1 * 60;
    
    NSString *hourString = [NSString stringWithFormat:@"%ld",(long)hours1];
    if (hourString.length == 1) {
        hourString = [@"0" stringByAppendingString:hourString];
    }
    NSString *minuteString = [NSString stringWithFormat:@"%ld",(long)minutes];
    if (minuteString.length == 1) {
        minuteString = [@"0" stringByAppendingString:minuteString];
    }
    NSString *secString = [NSString stringWithFormat:@"%ld",(long)sec];
    if (secString.length == 1) {
        secString = [@"0" stringByAppendingString:secString];
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@",hourString,minuteString,secString];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.haloRingView];
    [self.haloRingView addSubview:self.timerLabel];
    
    [self.haloRingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.circleView.mas_left).mas_offset(25.f);
        make.right.mas_equalTo(self.circleView.mas_right).mas_offset(-25.f);
        make.top.mas_equalTo(self.circleView.mas_top).mas_offset(25.f);
        make.bottom.mas_equalTo(self.circleView.mas_bottom).mas_offset(-25.f);
    }];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.haloRingView.mas_centerY);
        make.height.mas_equalTo(MKFont(30.f).lineHeight);
    }];
    
    [self.view addSubview:self.timerButton];
    [self.timerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.circleView.mas_bottom).mas_offset(20.f);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.view addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.timerButton.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - getter
- (MKTimerCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[MKTimerCircleView alloc] initWithFrame:CGRectMake(circleView_offset_X, defaultTopInset + 60.f, kScreenWidth - 2 * circleView_offset_X, kScreenWidth - 2 * circleView_offset_X)];
    }
    return _circleView;
}

- (UIImageView *)haloRingView {
    if (!_haloRingView) {
        _haloRingView = [[UIImageView alloc] init];
        _haloRingView.image = LOADIMAGE(@"haloRing", @"png");
        _haloRingView.userInteractionEnabled = YES;
    }
    return _haloRingView;
}

- (UILabel *)timerLabel {
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] init];
        _timerLabel.textColor = COLOR_NAVIBAR_CUSTOM;
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.font = MKFont(30.f);
        _timerLabel.text = @"Timer";
    }
    return _timerLabel;
}

- (UIButton *)timerButton {
    if (!_timerButton) {
        _timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _timerButton.backgroundColor = COLOR_NAVIBAR_CUSTOM;
        _timerButton.titleLabel.font = MKFont(15.f);
        [_timerButton setTitle:@"Set timer" forState:UIControlStateNormal];
        [_timerButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        _timerButton.layer.masksToBounds = YES;
        _timerButton.layer.cornerRadius = 14.f;
        [_timerButton addTapAction:self selector:@selector(timerButtonPressed)];
    }
    return _timerButton;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = RGBCOLOR(128, 128, 128);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = MKFont(14.f);
        _stateLabel.text = @"OFF after countdown";
    }
    return _stateLabel;
}

@end
