//
//  MKEnergyDataModel.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/15.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKEnergyDataModel : NSObject

- (void)startReadEnergyDatasWithScuBlock:(void (^)(NSArray *dailyList, NSArray *monthlyList, NSString *pulseConstant))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
