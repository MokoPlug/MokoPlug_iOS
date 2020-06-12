//
//  MKLifeBLEInterface+MKConfig.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEInterface+MKConfig.h"
#import "MKLifeBLECentralManager.h"
#import "CBPeripheral+MKLifeBLEAdd.h"
#import "MKLifeBLEAdopter.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#define centralManager [MKLifeBLECentralManager shared]

@implementation MKLifeBLEInterface (MKConfig)

+ (void)configDeviceName:(NSString *)deviceName
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
    NSString *len = [NSString stringWithFormat:@"%1lx",(unsigned long)deviceName.length];
    if (len.length == 1) {
        len = [@"0" stringByAppendingString:len];
    }
    NSString *commandString = [NSString stringWithFormat:@"b201%@%@",len,tempString];
    [self addTaskWithOperationID:mk_configDeviceNameOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configAdvInterval:(NSInteger)interval
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (intervalString.length == 1) {
        intervalString = [@"0" stringByAppendingString:intervalString];
    }
    NSString *commandString = [@"b20201" stringByAppendingString:intervalString];
    [self addTaskWithOperationID:mk_configAdvIntervalOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configSwitchStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"b2030101" : @"b2030100");
    [self addTaskWithOperationID:mk_configSwitchStatusOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configPowerOnSwitchStatus:(mk_lifeSwitchStatus)status
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = @"00";
    if (status == mk_lifeSwitchStatusPowerOn) {
        value = @"01";
    }else if (status == mk_lifeSwitchStatusRevertLast) {
        value = @"02";
    }
    NSString *commandString = [@"b20401" stringByAppendingString:value];
    [self addTaskWithOperationID:mk_configPowerOnSwitchStatusOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configOverloadProtectionValue:(NSInteger)value
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 10 || value > 3680) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [NSString stringWithFormat:@"%1lx",(unsigned long)value];
    if (valueString.length == 1) {
        valueString = [@"000" stringByAppendingString:valueString];
    }else if (valueString.length == 2) {
        valueString = [@"00" stringByAppendingString:valueString];
    }else if (valueString.length == 3) {
        valueString = [@"0" stringByAppendingString:valueString];
    }
    NSString *commandString = [@"b20502" stringByAppendingString:valueString];
    [self addTaskWithOperationID:mk_configOverloadProtectionValueOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)resetAccumulatedEnergyWithSucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    NSString *commandString = @"b20600";
    [self addTaskWithOperationID:mk_resetAccumulatedEnergyOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configCountdownValue:(long long)seconds
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (seconds < 0 || seconds > 86400) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [NSString stringWithFormat:@"%1lx",(unsigned long)seconds];
    if (valueString.length == 1) {
        valueString = [@"0000000" stringByAppendingString:valueString];
    }else if (valueString.length == 2) {
        valueString = [@"000000" stringByAppendingString:valueString];
    }else if (valueString.length == 3) {
        valueString = [@"00000" stringByAppendingString:valueString];
    }else if (valueString.length == 4) {
        valueString = [@"0000" stringByAppendingString:valueString];
    }else if (valueString.length == 5) {
        valueString = [@"000" stringByAppendingString:valueString];
    }else if (valueString.length == 6) {
        valueString = [@"00" stringByAppendingString:valueString];
    }else if (valueString.length == 7) {
        valueString = [@"0" stringByAppendingString:valueString];
    }
    NSString *commandString = [@"b20704" stringByAppendingString:valueString];
    [self addTaskWithOperationID:mk_configCountdownValueOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)resetFactoryWithSucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"b20800";
    [self addTaskWithOperationID:mk_resetFactoryOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configEnergyStorageParameters:(NSInteger)interval
                          energyValue:(NSInteger)energyValue
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 60 || energyValue < 1 || energyValue > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (intervalString.length == 1) {
        intervalString = [@"0" stringByAppendingString:intervalString];
    }
    NSString *energyValueString = [NSString stringWithFormat:@"%1lx",(unsigned long)energyValue];
    if (energyValueString.length == 1) {
        energyValueString = [@"0" stringByAppendingString:energyValueString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"b20902",intervalString,energyValueString];
    [self addTaskWithOperationID:mk_configEnergyStorageParametersOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

+ (void)configDeviceTime:(id <MKDeviceTimeProtocol>)protocol
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validTimeProtocol:protocol]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"b20a07" stringByAppendingString:[self getTimeString:protocol]];
    [self addTaskWithOperationID:mk_configDeviceDateOperation
                     commandData:commandString
                        sucBlock:sucBlock
                     failedBlock:failedBlock];
}

#pragma mark - task method
+ (void)addTaskWithOperationID:(mk_taskOperationID)operationID
                   commandData:(NSString *)commandData
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:operationID
                       characteristic:centralManager.peripheral.writeCharacteristic
                             resetNum:NO
                          commandData:commandData
                         successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"result"] boolValue];
        if (!success) {
            [self operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        sucBlock();
    }
                         failureBlock:failedBlock];
}

#pragma mark - private method
+ (BOOL)validTimeProtocol:(id <MKDeviceTimeProtocol>)protocol{
    if (![protocol conformsToProtocol:@protocol(MKDeviceTimeProtocol)]) {
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

+ (NSString *)getTimeString:(id <MKDeviceTimeProtocol>)protocol{
    
    unsigned long yearValue = protocol.year;
    NSString *yearString = [NSString stringWithFormat:@"%1lx",yearValue];
    if (yearString.length == 1) {
        yearString = [@"000" stringByAppendingString:yearString];
    }else if (yearString.length == 2) {
        yearString = [@"00" stringByAppendingString:yearString];
    }else if (yearString.length == 3) {
        yearString = [@"0" stringByAppendingString:yearString];
    }
    NSString *monthString = [NSString stringWithFormat:@"%1lx",(long)protocol.month];
    if (monthString.length == 1) {
        monthString = [@"0" stringByAppendingString:monthString];
    }
    NSString *dayString = [NSString stringWithFormat:@"%1lx",(long)protocol.day];
    if (dayString.length == 1) {
        dayString = [@"0" stringByAppendingString:dayString];
    }
    NSString *hourString = [NSString stringWithFormat:@"%1lx",(long)protocol.hour];
    if (hourString.length == 1) {
        hourString = [@"0" stringByAppendingString:hourString];
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(long)protocol.minutes];
    if (minString.length == 1) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *secString = [NSString stringWithFormat:@"%1lx",(long)protocol.second];
    if (secString.length == 1) {
        secString = [@"0" stringByAppendingString:secString];
    }
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
