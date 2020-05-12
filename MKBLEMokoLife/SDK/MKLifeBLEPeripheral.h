//
//  MKLifeBLEPeripheral.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBLEBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKLifeBLEPeripheral : NSObject<MKBLEBasePeripheralProtocol>

@property (nonatomic, strong, nonnull)CBPeripheral *peripheral;

@end

NS_ASSUME_NONNULL_END
