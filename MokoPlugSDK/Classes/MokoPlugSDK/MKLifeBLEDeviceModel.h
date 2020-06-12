//
//  MKLifeBLEDeviceModel.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/6.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKLifeBLEDeviceModel : NSObject

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, assign)NSInteger rssi;

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *macAddress;

/// Voltage, unit:V
@property (nonatomic, assign)CGFloat electronV;

/// Electric current，unit:mA
@property (nonatomic, assign)CGFloat electronA;

/// Power,unit:W
@property (nonatomic, assign)CGFloat electronP;

/// Load detection status
@property (nonatomic, assign)BOOL loadDetection;

/// Overload state
@property (nonatomic, assign)BOOL overloadState;

/// Socket switch status
@property (nonatomic, assign)BOOL switchStatus;

@end

NS_ASSUME_NONNULL_END
