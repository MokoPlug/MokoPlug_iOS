//
//  MKSettingDatasModel.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSettingDatasModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, copy)NSString *overloadValue;

@property (nonatomic, copy)NSString *powerReInterval;

@property (nonatomic, copy)NSString *powerChangeNoti;

@property (nonatomic, copy)NSString *energyConsumption;

- (void)startReadDatasFromDeviceWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
