//
//  MKLifeBLEInterface.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEInterface.h"
#import "MKLifeBLECentralManager.h"
#import "CBPeripheral+MKLifeBLEAdd.h"

#define centralManager [MKLifeBLECentralManager shared]

@implementation MKLifeBLEInterface

+ (void)readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readDeviceNameOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00100"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readAdvIntervalOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00200"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readSwitchStatusOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00300"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readPowerOnSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readPowerOnSwitchStatusOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00400"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readLoadStatusOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00500"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readOverloadProtectionValueWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readOverloadProtectionValueOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00600"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readVCPValueWithSucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readVCPValueOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00700"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readAccumulatedEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readAccumulatedEnergyOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00800"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readCountdownValueWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readCountdownValueOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00900"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readFirmwareVersionWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readFirmwareVersionOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00a00"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readMacAddressOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00b00"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readEnergyStorageParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readEnergyStorageParametersOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b00c00"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readHistoricalEnergyWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readHistoricalEnergyOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:YES
                          commandData:@"b00d00"
                         successBlock:^(id  _Nonnull returnData) {
        //解析
    } failureBlock:failedBlock];
}

+ (void)readOverLoadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_readOverLoadStatusOperation
                       characteristic:centralManager.peripheral.readCharacteristic
                             resetNum:NO
                          commandData:@"b01000"
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
