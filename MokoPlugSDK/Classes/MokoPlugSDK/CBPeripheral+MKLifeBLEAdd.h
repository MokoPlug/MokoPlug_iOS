//
//  CBPeripheral+MKLifeBLEAdd.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKLifeBLEAdd)

/// WRITE_NO_RESPONSE / NOTIFY
@property (nonatomic, strong, readonly)CBCharacteristic *readCharacteristic;
/// WRITE_NO_RESPONSE / NOTIFY
@property (nonatomic, strong, readonly)CBCharacteristic *writeCharacteristic;
/// WRITE_NO_RESPONSE / NOTIFY
@property (nonatomic, strong, readonly)CBCharacteristic *stateCharacteristic;

- (void)updateCharacterWithService:(CBService *)service;

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)connectSuccess;

- (void)setNil;

@end

NS_ASSUME_NONNULL_END
