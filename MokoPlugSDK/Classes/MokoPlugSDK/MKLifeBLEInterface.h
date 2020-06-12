//
//  MKLifeBLEInterface.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLifeBLEInterface : NSObject

/// Read device name (broadcast).
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast interval, the data unit read back is 100ms.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read switch status.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the switch status when the device is powered on, 0x00 means that the switch status is off when the device is powered on, 0x01 means that the switch status is on when the device is powered on, and 0x02 means that the switch resumes before power off when the device is powered on status.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readPowerOnSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read load status.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read overload protection value in W.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readOverloadProtectionValueWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the real-time voltage, electric current and power of the device. The voltage unit is 0.1V, the electric current unit is mA, and the power unit is 0.1W.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readVCPValueWithSucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the accumulated electrical energy, the total accumulated electrical energy revolutions, the actual electrical energy is revolutions/pulse constant kwh.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readAccumulatedEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read countdown.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readCountdownValueWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read firmware version.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readFirmwareVersionWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read MAC address.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Reading cumulative energy storage parameters.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readEnergyStorageParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read historical accumulated energy, up to 30 days of data.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readHistoricalEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read overload status.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readOverLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read hourly data for the day.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readEnergyDataOfTodayWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read pulse constant.
/// @param sucBlock Successful callback
/// @param failedBlock Failure callback
+ (void)readPulseConstantWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
