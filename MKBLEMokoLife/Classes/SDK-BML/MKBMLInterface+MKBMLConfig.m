//
//  MKBMLInterface+MKBMLConfig.m
//  MKBLEMokoLife_Example
//
//  Created by aa on 2021/4/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBMLInterface+MKBMLConfig.h"

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBMLCentralManager.h"
#import "CBPeripheral+MKBMLAdd.h"
#import "MKBMLOperationID.h"
#import "MKBMLAdopter.h"

#define centralManager [MKBMLCentralManager shared]
#define peripheral [MKBMLCentralManager shared].peripheral

@implementation MKBMLInterface (MKBMLConfig)

+ (void)bml_configDeviceName:(NSString *)deviceName
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceName) || deviceName.length < 1 || deviceName.length > 11
        || ![MKBLEBaseSDKAdopter asciiString:deviceName]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *len = [MKBLEBaseSDKAdopter fetchHexValue:deviceName.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"b201%@%@",len,tempString];
    [self addTaskWithOperationID:mk_bml_taskConfigDeviceNameOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configAdvInterval:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"b20201" stringByAppendingString:intervalString];
    [self addTaskWithOperationID:mk_bml_taskConfigAdvIntervalOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configSwitchStatus:(BOOL)isOn
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"b2030101" : @"b2030100");
    [self addTaskWithOperationID:mk_bml_taskConfigSwitchStatusOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configPowerOnSwitchStatus:(mk_bml_plugSwitchStatus)status
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = @"00";
    if (status == mk_bml_plugSwitchStatusPowerOn) {
        value = @"01";
    }else if (status == mk_bml_plugSwitchStatusRevertLast) {
        value = @"02";
    }
    NSString *commandString = [@"b20401" stringByAppendingString:value];
    [self addTaskWithOperationID:mk_bml_taskConfigPowerOnSwitchStatusOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configOverloadProtectionValue:(NSInteger)value
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 10 || value > 3680) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:2];
    NSString *commandString = [@"b20502" stringByAppendingString:valueString];
    [self addTaskWithOperationID:mk_bml_taskConfigOverloadProtectionValueOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_resetAccumulatedEnergyWithSucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"b20600";
    [self addTaskWithOperationID:mk_bml_taskResetAccumulatedEnergyOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configCountdownValue:(long long)seconds
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (seconds < 0 || seconds > 86400) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:seconds byteLen:4];
    NSString *commandString = [@"b20704" stringByAppendingString:valueString];
    [self addTaskWithOperationID:mk_bml_taskConfigCountdownValueOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_resetFactoryWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"b20800";
    [self addTaskWithOperationID:mk_bml_taskResetFactoryOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configEnergyStorageParameters:(NSInteger)interval
                              energyValue:(NSInteger)energyValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 60 || energyValue < 1 || energyValue > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *energyValueString = [MKBLEBaseSDKAdopter fetchHexValue:energyValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"b20902",intervalString,energyValueString];
    [self addTaskWithOperationID:mk_bml_taskConfigEnergyStorageParametersOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)bml_configDeviceTime:(id <MKBMLDeviceTimeProtocol>)protocol
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validTimeProtocol:protocol]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"b20a07" stringByAppendingString:[self getTimeString:protocol]];
    [self addTaskWithOperationID:mk_bml_taskConfigDeviceDateOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

#pragma mark - task method
+ (void)addTaskWithOperationID:(mk_bml_taskOperationID)operationID
                   commandData:(NSString *)commandData
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:operationID
                       characteristic:peripheral.bml_write
                             resetNum:NO
                          commandData:commandData
                             sucBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"result"] boolValue];
        if (!success) {
            [self operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        sucBlock();
    }
                          failedBlock:failedBlock];
}

#pragma mark - private method
+ (BOOL)validTimeProtocol:(id <MKBMLDeviceTimeProtocol>)protocol{
    if (![protocol conformsToProtocol:@protocol(MKBMLDeviceTimeProtocol)]) {
        return NO;
    }
    if (protocol.year < 2000 || protocol.year > 2099) {
        return NO;
    }
    if (protocol.month < 1 || protocol.month > 12) {
        return NO;
    }
    if (protocol.day < 1 || protocol.day > 31) {
        return NO;
    }
    if (protocol.hour < 0 || protocol.hour > 23) {
        return NO;
    }
    if (protocol.minutes < 0 || protocol.minutes > 59) {
        return NO;
    }
    return YES;
}

+ (NSString *)getTimeString:(id <MKBMLDeviceTimeProtocol>)protocol{
    
    unsigned long yearValue = protocol.year;
    NSString *yearString = [MKBLEBaseSDKAdopter fetchHexValue:yearValue byteLen:2];
    NSString *monthString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.month byteLen:1];
    NSString *dayString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.day byteLen:1];
    NSString *hourString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.hour byteLen:1];
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minutes byteLen:1];
    NSString *secString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.second byteLen:1];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minString,secString];
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-999 message:@"Params error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-999 message:@"Set params error"];
            block(error);
        }
    });
}

@end
