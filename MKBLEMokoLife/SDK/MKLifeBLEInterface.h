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

/// 读取设备名字(广播)
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取广播间隔,读取回来的数据单位是100ms
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取开关状态
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取设备刚上电时开关状态,0x00代表设备刚上电时，开关状态为关，0x01代表设备刚上电时，开关状态为开，0x02代表设备刚上电时，开关恢复断电前的状态
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readPowerOnSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取负载状态
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取过载保护值,单位为W
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readOverloadProtectionValueWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取设备实时的电压、电流、功率.电压单位0.1V，电流单位mA，功率单位0.1W
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readVCPValueWithSucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取累计电能，总的累计电能转数，实际电能为转数/脉冲常数 kwh
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readAccumulatedEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取倒计时
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readCountdownValueWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取固件版本
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readFirmwareVersionWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取MAC地址
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取累计电能存储参数
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readEnergyStorageParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取历史累计电能,最多30天数据
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readHistoricalEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取过载状态
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readOverLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取当天每小时数据
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readEnergyDataOfTodayWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// 读取脉冲常数
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)readPulseConstantWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
