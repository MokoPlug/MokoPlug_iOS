//
//  MKLifeBLEPeripheral.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEPeripheral.h"

#import "CBPeripheral+MKLifeBLEAdd.h"

@implementation MKLifeBLEPeripheral

#pragma mark - MKBLEBasePeripheralProtocol

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:@"FFB0"]]; //自定义
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFB0"]]) {
            NSArray *charList = @[[CBUUID UUIDWithString:@"FFB0"],[CBUUID UUIDWithString:@"FFB1"],[CBUUID UUIDWithString:@"FFB2"]];
            [self.peripheral discoverCharacteristics:charList forService:service];
            break;
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral connectSuccess];
}

- (void)setNil {
    [self.peripheral setNil];
}

@end
