//
//  MKLifeBLEAdopter.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/6.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKLifeBLEAdopter.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKLifeBLEAdopter

+ (NSDictionary *)parseVCPValue:(NSString *)value {
    if (value.length != 14) {
        return @{};
    }
    CGFloat v = [MKBLEBaseSDKAdopter getDecimalWithHex:value range:NSMakeRange(0, 4)] * 0.1;
    CGFloat a = [MKBLEBaseSDKAdopter getDecimalWithHex:value range:NSMakeRange(4, 6)];
    CGFloat p = [MKBLEBaseSDKAdopter getDecimalWithHex:value range:NSMakeRange(10, 4)] * 0.1;
    return @{
        @"v":@(v),
        @"a":@(a),
        @"p":@(p)
    };
}

+ (NSArray *)parseHistoricalEnergy:(NSString *)content {
    NSInteger number = content.length / 8;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < number; i ++) {
        NSString *subContent = [content substringWithRange:NSMakeRange(i * 8, 8)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(0, 2)];
        NSString *rotationsNumber = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(2, 6)];
        NSDictionary *dic = @{
            @"index":index,
            @"rotationsNumber":rotationsNumber
        };
        [dataList addObject:dic];
    }
    return dataList;
}

+ (NSArray *)parseEnergyOfToday:(NSString *)content {
    NSInteger number = content.length / 6;
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < number; i ++) {
        NSString *subContent = [content substringWithRange:NSMakeRange(i * 6, 6)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(0, 2)];
        NSString *rotationsNumber = [MKBLEBaseSDKAdopter getDecimalStringWithHex:subContent range:NSMakeRange(2, 4)];
        NSDictionary *dic = @{
            @"index":index,
            @"rotationsNumber":rotationsNumber
        };
        [dataList addObject:dic];
    }
    return dataList;
}

@end
