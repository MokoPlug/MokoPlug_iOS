//
//  MKPowerController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKPowerController.h"
#import "MKPowerCircleView.h"

static CGFloat circleView_offset_X = 40.f;

@interface MKPowerController ()

@property (nonatomic, strong)MKPowerCircleView *circleView;

@end

@implementation MKPowerController

- (void)dealloc {
    NSLog(@"MKPowerController销毁");
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
    [self.circleView updateProgress:1.f];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setTitle:@"H" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    [self.view addSubview:self.circleView];
}

#pragma mark - getter
- (MKPowerCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[MKPowerCircleView alloc] initWithFrame:CGRectMake(circleView_offset_X, defaultTopInset + 60.f, kScreenWidth - 2 * circleView_offset_X, kScreenWidth - 2 * circleView_offset_X)];
    }
    return _circleView;
}

@end
