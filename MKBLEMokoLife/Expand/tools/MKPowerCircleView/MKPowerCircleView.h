//
//  MKPowerCircleView.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPowerCircleView : UIView

///最大3600，超过3600表示进度为1
/// @param powerValue powerValue
- (void)updatePowerValues:(float)powerValue;

@end

NS_ASSUME_NONNULL_END
