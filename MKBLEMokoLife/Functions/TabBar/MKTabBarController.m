//
//  MKTabBarController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTabBarController.h"

#import "MKPowerController.h"
#import "MKEnergyController.h"
#import "MKTimerController.h"
#import "MKSettingController.h"

@interface MKTabBarController ()

@end

@implementation MKTabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"MKTabBarController销毁");
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKLifeBLECentralManager shared] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubControllers];
    [self addNotifications];
}

#pragma mark - Notification

- (void)gotoRootViewController{
    NSString *msg = @"Please confirm again whether to disconnect the device";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MKNeedResetRootControllerToScanPage" object:nil userInfo:nil];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)disconnectAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:@"The device is disconnected"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoRootViewController];
    }];
    [alertController addAction:exitAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController)
                                                 name:@"MKCentralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController)
                                                 name:@"MKPopToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectAlert)
                                                 name:mk_peripheralConnectStateChangedNotification
                                               object:nil];
}

- (void)setupSubControllers {
    MKPowerController *powerPage = [[MKPowerController alloc] init];
    powerPage.tabBarItem.title = @"Power";
    powerPage.tabBarItem.image = LOADIMAGE(@"powerTabBarItemUnselected", @"png");
    powerPage.tabBarItem.selectedImage = LOADIMAGE(@"powerTabBarItemSelected", @"png");
    UINavigationController *powerNav = [[UINavigationController alloc] initWithRootViewController:powerPage];
    
    MKEnergyController *energyPage = [[MKEnergyController alloc] init];
    energyPage.tabBarItem.title = @"Energy";
    energyPage.tabBarItem.image = LOADIMAGE(@"energyTabBarItemUnselected", @"png");
    energyPage.tabBarItem.selectedImage = LOADIMAGE(@"energyTabBarItemSelected", @"png");
    UINavigationController *energyNav = [[UINavigationController alloc] initWithRootViewController:energyPage];
    
    MKTimerController *timerPage = [[MKTimerController alloc] init];
    timerPage.tabBarItem.title = @"Timer";
    timerPage.tabBarItem.image = LOADIMAGE(@"timerTabBarItemUnselected", @"png");
    timerPage.tabBarItem.selectedImage = LOADIMAGE(@"timerTabBarItemSelected", @"png");
    UINavigationController *timerNav = [[UINavigationController alloc] initWithRootViewController:timerPage];

    MKSettingController *settingPage = [[MKSettingController alloc] init];
    settingPage.tabBarItem.title = @"Settings";
    settingPage.tabBarItem.image = LOADIMAGE(@"settingTabBarItemUnselected", @"png");
    settingPage.tabBarItem.selectedImage = LOADIMAGE(@"settingTabBarItemSelected", @"png");
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingPage];
    
    self.viewControllers = @[powerNav, energyNav, timerNav, settingNav];
}

@end
