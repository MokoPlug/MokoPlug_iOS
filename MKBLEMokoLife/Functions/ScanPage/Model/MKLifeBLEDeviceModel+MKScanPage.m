//
//  MKLifeBLEDeviceModel+MKScanPage.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/6.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEDeviceModel+MKScanPage.h"
#import <objc/runtime.h>

static const char *indexKey = "indexKey";
static const char *IdentifierKey = "IdentifierKey";

@implementation MKLifeBLEDeviceModel (MKScanPage)

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, &IdentifierKey, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)identifier {
    return objc_getAssociatedObject(self, &IdentifierKey);
}

@end
