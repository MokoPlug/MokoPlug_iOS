//
//  MKUpdateCheckController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/16.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKUpdateCheckController.h"

#import "MKUpdateController.h"

#import "MKDFUAdopter.h"

@interface MKUpdateCheckController ()<MKUpdateControllerDelegate>

@property (nonatomic, strong)UILabel *currentLabel;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *fileNameLabel;

@property (nonatomic, strong)UIButton *addButton;

@property (nonatomic, strong)UIButton *startButton;

@property (nonatomic, strong)MKDFUAdopter *adopter;

@property (nonatomic, copy)NSString *fileName;

@end

@implementation MKUpdateCheckController

- (void)dealloc {
    NSLog(@"MKUpdateCheckController销毁");
    [self.adopter cancel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readFirmwareVersion];
}

#pragma mark - MKUpdateControllerDelegate
- (void)mk_selectedFileName:(NSString *)fileName {
    _fileName = nil;
    _fileName = fileName;
    self.fileNameLabel.text = SafeStr(_fileName);
}

#pragma mark - event method
- (void)addButtonPressed {
    MKUpdateController *vc = [[MKUpdateController alloc] init];
    vc.delegate = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startButtonPressed {
    if (!ValidStr(self.fileName)) {
        [self.view showCentralToast:@"File name cannot be empty!"];
        return;
    }
    WS(weakSelf);
    self.leftButton.enabled = NO;
    [self.adopter dfuUpdateWithFileName:self.fileName target:weakSelf];
}

#pragma mark - interface
- (void)readFirmwareVersion {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface readFirmwareVersionWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        self.versionLabel.text = returnData[@"result"][@"firmware"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setHidden:YES];
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"Check Update";
    
    [self.view addSubview:self.currentLabel];
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(defaultTopInset + 40.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.view addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.currentLabel.mas_bottom).mas_offset(16.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.view addSubview:self.msgLabel];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text andFont:self.msgLabel.font andMaxSize:CGSizeMake(kScreenWidth - 2 * 30.f, MAXFLOAT)];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.versionLabel.mas_bottom).mas_offset(60.f);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-36.f);
        make.width.mas_equalTo(35.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(40.f);
    }];
    [self.view addSubview:self.fileNameLabel];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36.f);
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-12.f);
        make.centerY.mas_equalTo(self.addButton.mas_centerY);
        make.height.mas_equalTo(40.f);
    }];
    [self.view addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(36.f);
        make.right.mas_equalTo(-36.f);
        make.top.mas_equalTo(self.fileNameLabel.mas_bottom).mas_offset(30.f);
        make.height.mas_equalTo(40.f);
    }];
}

#pragma mark - getter
- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.textColor = COLOR_NAVIBAR_CUSTOM;
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.font = MKFont(14.f);
        _currentLabel.text = @"Current Firmware";
    }
    return _currentLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = RGBCOLOR(51, 51, 51);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = MKFont(14.f);
    }
    return _versionLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = RGBCOLOR(51, 51, 51);
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.numberOfLines = 0;
        _msgLabel.text = @"Perform an over-the-air firmware update?Please select a file.";
    }
    return _msgLabel;
}

- (UILabel *)fileNameLabel {
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc] init];
        _fileNameLabel.backgroundColor = RGBCOLOR(245, 245, 245);
        _fileNameLabel.textColor = RGBCOLOR(51, 51, 51);
        _fileNameLabel.textAlignment = NSTextAlignmentCenter;
        _fileNameLabel.font = MKFont(14.f);
        
        _fileNameLabel.layer.masksToBounds = YES;
        _fileNameLabel.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _fileNameLabel.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _fileNameLabel.layer.cornerRadius = 20.f;
    }
    return _fileNameLabel;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:LOADIMAGE(@"firmware_select_fileIcon", @"png") forState:UIControlStateNormal];
        [_addButton addTapAction:self selector:@selector(addButtonPressed)];
    }
    return _addButton;
}

- (UIButton *)startButton {
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.backgroundColor = COLOR_NAVIBAR_CUSTOM;
        _startButton.titleLabel.font = MKFont(14.f);
        [_startButton setTitle:@"Start Update" forState:UIControlStateNormal];
        [_startButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        _startButton.layer.masksToBounds = YES;
        _startButton.layer.cornerRadius = 20.f;
        [_startButton addTapAction:self selector:@selector(startButtonPressed)];
    }
    return _startButton;
}

- (MKDFUAdopter *)adopter {
    if (!_adopter) {
        _adopter = [[MKDFUAdopter alloc] init];
    }
    return _adopter;
}

@end
