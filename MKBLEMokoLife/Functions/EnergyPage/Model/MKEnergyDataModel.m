//
//  MKEnergyDataModel.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/15.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKEnergyDataModel.h"

@interface MKEnergyDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKEnergyDataModel

- (void)startReadEnergyDatasWithScuBlock:(void (^)(NSArray *dailyList, NSArray *monthlyList, NSString *pulseConstant))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        NSString *pulseConstant = [self readPulseConstant];
        if (!pulseConstant) {
            [self operationFailedBlockWithMsg:@"Read pulseConstant error" block:failedBlock];
            return ;
        }
        NSArray *tempMonth = [self readMonthlyList];
        if (!tempMonth) {
            [self operationFailedBlockWithMsg:@"Read monthly data error" block:failedBlock];
            return ;
        }
        NSArray *tempDaily = [self readDailyList];
        if (!tempDaily) {
            [self operationFailedBlockWithMsg:@"Read daily data error" block:failedBlock];
            return ;
        }
        moko_dispatch_main_safe(^{
            sucBlock(tempDaily, tempMonth, pulseConstant);
        });
    });
}

#pragma mark - interface
- (NSString *)readPulseConstant {
    __block NSString *pulseConstant = nil;
    [MKLifeBLEInterface readPulseConstantWithSucBlock:^(id  _Nonnull returnData) {
        pulseConstant = returnData[@"result"][@"pulseConstant"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return pulseConstant;
}

- (NSArray *)readMonthlyList {
    __block NSArray *dataList = nil;
    [MKLifeBLEInterface readHistoricalEnergyWithSucBlock:^(id  _Nonnull returnData) {
        dataList = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return dataList;
}

- (NSArray *)readDailyList {
    __block NSArray *dataList = nil;
    [MKLifeBLEInterface readEnergyDataOfTodayWithSucBlock:^(id  _Nonnull returnData) {
        dataList = returnData[@"result"][@"dataList"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return dataList;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"readEnergyData"
                                                    code:-999
                                                userInfo:@{@"errorInfo":SafeStr(msg)}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("readParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
