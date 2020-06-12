//
//  MKLifeBLEDeviceModel+MKScanPage.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/6.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKLifeBLEDeviceModel (MKScanPage)

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
