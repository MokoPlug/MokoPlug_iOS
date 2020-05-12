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
    mk_lifeSwitchStatusPowerOff,        //开关状态为关
    mk_lifeSwitchStatusPowerOn,         //开关状态为开
    mk_lifeSwitchStatusRevertLast,      //开关恢复断电前的状态
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

/// 设置设备名字
/// @param deviceName 设备名字，1~11个ascii字符
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configDeviceName:(NSString *)deviceName
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置广播间隔
/// @param interval 广播间隔，1~100,单位100ms
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configAdvInterval:(NSInteger)interval
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置开关状态
/// @param isOn isOn
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configSwitchStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置上电状态
/// @param status status
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configPowerOnSwitchStatus:(mk_lifeSwitchStatus)status
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置过载保护值
/// @param value 设备过载保护值，单位为W,10~3680
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configOverloadProtectionValue:(NSInteger)value
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 重置累计电能
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)resetAccumulatedEnergyWithSucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置倒计时
/// @param seconds 倒计时值，单位为秒,0~86400
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configCountdownValue:(long long)seconds
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// 恢复出厂设置
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)resetFactoryWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// 设置累计电能存储参数
/// @param interval 存储时间间隔，区间为1min—60min
/// @param energyValue 电能变化值,区间为1%-100%
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configEnergyStorageParameters:(NSInteger)interval
                          energyValue:(NSInteger)energyValue
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// 同步设备时间
/// @param protocol protocol
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
+ (void)configDeviceTime:(id <MKDeviceTimeProtocol>)protocol
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
