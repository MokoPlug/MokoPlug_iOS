//
//  MKModifyNormalDatasController.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKModifyPageType) {
    MKModifyDeviceNamePage,                  //修改设备名称
    MKModifyBroadcastFrequencyPage,          //修改广播周期
    MKModifyOverloadValuePage,               //修改过载保护
    MKModifyPowerReportIntervalPage,         //修改存储电能时间间隔
    MKModifyPowerChangeNotificationPage,     //修改电能变化值
};

@interface MKModifyNormalDatasController : MKBaseViewController

/// 当前页面是设置哪个参数的
@property (nonatomic, assign)MKModifyPageType pageType;

/// 当前参数值
@property (nonatomic, copy)NSString *textFieldValue;

/// 对于累计电能存储参数设置的时候需要知道存储时间间隔和电能变化值，所以当MKModifyPowerReportIntervalPage这种情况，需要把energyValue传过来，MKModifyPowerChangeNotificationPage需要把存储时间间隔传过来
@property (nonatomic, copy)NSString *powerValue;

@end

NS_ASSUME_NONNULL_END
