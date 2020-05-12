//
//  CBPeripheral+MKLifeBLEAdd.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "CBPeripheral+MKLifeBLEAdd.h"
#import <objc/runtime.h>

static const char *readCharacterKey = "readCharacterKey";
static const char *readCharacterNotifyKey = "readCharacterNotifyKey";

static const char *writeCharacterKey = "writeCharacterKey";
static const char *writeCharacterNotifyKey = "writeCharacterNotifyKey";

static const char *stateCharacterKey = "stateCharacterKey";
static const char *stateCharacterNotifyKey = "stateCharacterNotifyKey";

@implementation CBPeripheral (MKLifeBLEAdd)

#pragma mark - public method
- (void)updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if (![service.UUID isEqual:[CBUUID UUIDWithString:@"FFB0"]] || characteristicList.count == 0) {
        return;
    }
    for (CBCharacteristic *characteristic in characteristicList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB0"]]) {
            objc_setAssociatedObject(self, &readCharacterKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB1"]]) {
            objc_setAssociatedObject(self, &writeCharacterKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB2"]]) {
            objc_setAssociatedObject(self, &stateCharacterKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB0"]]) {
        objc_setAssociatedObject(self, &readCharacterNotifyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB1"]]) {
        objc_setAssociatedObject(self, &writeCharacterNotifyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFB2"]]) {
        objc_setAssociatedObject(self, &stateCharacterNotifyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)connectSuccess {
    if (![objc_getAssociatedObject(self, &readCharacterNotifyKey) boolValue]
        || ![objc_getAssociatedObject(self, &writeCharacterNotifyKey) boolValue]
        || ![objc_getAssociatedObject(self, &stateCharacterNotifyKey) boolValue]) {
        return NO;
    }
    if (!self.readCharacteristic || !self.writeCharacteristic || !self.stateCharacteristic) {
        return NO;
    }
    return YES;
}

- (void)setNil {
    objc_setAssociatedObject(self, &readCharacterKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &readCharacterNotifyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &writeCharacterKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &writeCharacterNotifyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &stateCharacterKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &stateCharacterNotifyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CBCharacteristic *)readCharacteristic {
    return objc_getAssociatedObject(self, &readCharacterKey);
}

- (CBCharacteristic *)writeCharacteristic {
    return objc_getAssociatedObject(self, &writeCharacterKey);
}

- (CBCharacteristic *)stateCharacteristic {
    return objc_getAssociatedObject(self, &stateCharacterKey);
}

@end
