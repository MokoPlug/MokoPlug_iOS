//
//  MKTimerController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTimerController.h"

#import "MKDeviceInfoController.h"

@interface MKTimerController ()

@end

@implementation MKTimerController

- (void)dealloc {
    NSLog(@"MKTimerController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
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

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
}

@end
