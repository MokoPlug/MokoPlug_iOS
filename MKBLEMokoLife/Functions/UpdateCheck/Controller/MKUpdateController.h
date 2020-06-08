//
//  MKUpdateController.h
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKUpdateControllerDelegate <NSObject>

- (void)mk_selectedFileName:(NSString *)fileName;

@end

@interface MKUpdateController : MKBaseViewController

@property (nonatomic, weak)id <MKUpdateControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
