//
//  MKConfigDeviceDateModel.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/16.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKConfigDeviceDateModel : NSObject<MKDeviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger second;

@end

NS_ASSUME_NONNULL_END
