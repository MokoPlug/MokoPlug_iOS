//
//  MKLifeBLEInterface+MKConfig.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEInterface.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lifeSwitchStatus) {
    mk_lifeSwitchStatusPowerOff,        //off
    mk_lifeSwitchStatusPowerOn,         //on
    mk_lifeSwitchStatusRevertLast,      //The switch returns to the state before the power failure.
};

@protocol MKDeviceTimeProtocol <NSObject>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger second;

@end

@interface MKLifeBLEInterface (MKConfig)

/// Set device name.
/// @param deviceName Device name, 1~11 ascii characters.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configDeviceName:(NSString *)deviceName
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the broadcast interval.
/// @param interval Broadcast interval, 1~100, unit 100ms.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configAdvInterval:(NSInteger)interval
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the switch state.
/// @param isOn isOn
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configSwitchStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the power-on state.
/// @param status status
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configPowerOnSwitchStatus:(mk_lifeSwitchStatus)status
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Set overload protection value.
/// @param value Equipment overload protection value, unit is W,10~3680.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configOverloadProtectionValue:(NSInteger)value
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset accumulated energy.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)resetAccumulatedEnergyWithSucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Set countdown.
/// @param seconds Countdown value, in seconds, 0~86400
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configCountdownValue:(long long)seconds
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)resetFactoryWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Set cumulative energy storage parameters.
/// @param interval Storage time interval, the interval is 1min-60min.
/// @param energyValue Energy change value, the range is 1-100 (1%-100%).
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configEnergyStorageParameters:(NSInteger)interval
                          energyValue:(NSInteger)energyValue
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Set the time for the device.
/// @param protocol protocol
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)configDeviceTime:(id <MKDeviceTimeProtocol>)protocol
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
