//
//  MKBMLDeviceModel.h
//  MKBLEMokoLife
//
//  Created by aa on 2021/4/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBMLDeviceModel : NSObject

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *macAddress;

/// 电压，单位V
@property (nonatomic, assign)CGFloat electronV;

/// 电流 mA
@property (nonatomic, assign)NSInteger electronA;

/// 功率 W
@property (nonatomic, assign)float electronP;

/// 负载检测
@property (nonatomic, assign)BOOL loadDetection;

/// 过载状态
@property (nonatomic, assign)BOOL overloadState;

/// 插座开关状态
@property (nonatomic, assign)BOOL switchStatus;

@end

NS_ASSUME_NONNULL_END
