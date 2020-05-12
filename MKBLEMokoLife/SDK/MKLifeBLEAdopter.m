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

+ (BOOL)asciiString:(NSString *)content {
    NSInteger strlen = content.length;
    NSInteger datalen = [[content dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
}

+ (NSString *)getBinaryByhex:(NSString *)hex{
    if (!MKValidStr(hex) || hex.length != 2 || ![MKBLEBaseSDKAdopter checkHexCharacter:hex]) {
        return @"";
    }
    NSDictionary *hexDic = @{
                             @"0":@"0000",@"1":@"0001",@"2":@"0010",
                             @"3":@"0011",@"4":@"0100",@"5":@"0101",
                             @"6":@"0110",@"7":@"0111",@"8":@"1000",
                             @"9":@"1001",@"A":@"1010",@"a":@"1010",
                             @"B":@"1011",@"b":@"1011",@"C":@"1100",
                             @"c":@"1100",@"D":@"1101",@"d":@"1101",
                             @"E":@"1110",@"e":@"1110",@"F":@"1111",
                             @"f":@"1111",
                             };
    NSString *binaryString = @"";
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,
                        [NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
}

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

@end
