//
//  MKModifyNormalDatasController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKModifyNormalDatasController.h"

@interface MKModifyNormalDatasController ()

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UIButton *confirmButton;

@end

@implementation MKModifyNormalDatasController

- (void)dealloc {
    NSLog(@"MKModifyNameController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - event method
- (void)confirmButtonPressed {
    if (!ValidStr(self.textField.text)) {
        [self.view showCentralToast:@"Param cannot be empty"];
        return;
    }
    if (self.pageType == MKModifyDeviceNamePage) {
        [self configDeviceName];
        return;
    }
    if (self.pageType == MKModifyBroadcastFrequencyPage) {
        [self configAdvInterval];
        return;
    }
    if (self.pageType == MKModifyOverloadValuePage) {
        [self configOverloadValue];
        return;
    }
    if (self.pageType == MKModifyPowerReportIntervalPage || self.pageType == MKModifyPowerChangeNotificationPage) {
        [self configPowerValue];
        return;
    }
}

#pragma mark - interface
- (void)configDeviceName {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configDeviceName:self.textField.text sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configAdvInterval {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configAdvInterval:[self.textField.text integerValue] sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configOverloadValue {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configOverloadProtectionValue:[self.textField.text integerValue] sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configPowerValue {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    NSInteger interval = (self.pageType == MKModifyPowerReportIntervalPage ? [self.textField.text integerValue] : [self.powerValue integerValue]);
    NSInteger energy = (self.pageType == MKModifyPowerChangeNotificationPage ? [self.textField.text integerValue] : [self.powerValue integerValue]);
    [MKLifeBLEInterface configEnergyStorageParameters:interval energyValue:energy sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    self.defaultTitle = [self fetchTitle];
    self.textField = [self loadTextField];
    self.textField.text = self.textFieldValue;
    
    UIView *textView = [self textView];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(defaultTopInset + 40.f);
        make.height.mas_equalTo(40.f);
    }];
    [textView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(textView.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(40.f);
    }];
}

#pragma mark - getter

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = COLOR_NAVIBAR_CUSTOM;
        _confirmButton.titleLabel.font = MKFont(18.f);
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        
        [_confirmButton.layer setMasksToBounds:YES];
        [_confirmButton.layer setCornerRadius:20.f];
        [_confirmButton addTapAction:self selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

- (UIView *)textView {
    UIView *textView = [[UIView alloc] init];
    textView.backgroundColor = RGBCOLOR(245, 245, 245);
    
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = RGBCOLOR(217, 217, 217).CGColor;
    textView.layer.borderWidth = 0.5f;
    textView.layer.cornerRadius = 20.f;
    return textView;
}

- (UITextField *)loadTextField {
    mk_CustomTextFieldType type = normalInput;
    if (self.pageType != MKModifyDeviceNamePage) {
        type = realNumberOnly;
    }
    UITextField *textField = [[UITextField alloc] initWithTextFieldType:type];
    textField.backgroundColor = RGBCOLOR(245, 245, 245);
    textField.textColor = RGBCOLOR(128, 128, 128);
    textField.font = MKFont(15.f);
    textField.textAlignment = NSTextAlignmentLeft;
    textField.borderStyle = UITextBorderStyleNone;
    return textField;
}

- (NSString *)fetchTitle {
    switch (self.pageType) {
        case MKModifyDeviceNamePage:
            return self.textFieldValue;
        case MKModifyBroadcastFrequencyPage:
            return @"Broadcast frequency";
        case MKModifyOverloadValuePage:
            return @"Overload value";
        case MKModifyPowerReportIntervalPage:
            return @"Power reporting Interval";
        case MKModifyPowerChangeNotificationPage:
            return @"Power change notification";
    }
}

@end
