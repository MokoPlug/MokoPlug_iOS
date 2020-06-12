//
//  MKLifeBLECentralManager.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/5.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBLEBaseDataProtocol.h"

#import "MKLifeBLEOperationID.h"

NS_ASSUME_NONNULL_BEGIN

//Notification of device connection status changes.
extern NSString *const mk_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_centralManagerStateChangedNotification;

//Notification of changes in switch status
extern NSString *const mk_receiveSwitchStatusChangedNotification;
//Notification of changes in load detection status
extern NSString *const mk_receiveLoadStatusChangedNotification;
//Notification of changes in overload protection status
extern NSString *const mk_receiveOverloadProtectionValueChangedNotification;
//Countdown notification
extern NSString *const mk_receiveCountdownNotification;
//Current voltage, current, power notification
extern NSString *const mk_receiveEnergyVCPNotification;
//Current energy data notification
extern NSString *const mk_receiveCurrentEnergyNotification;

@class CBCentralManager,CBPeripheral;
@class MKLifeBLEDeviceModel;
@protocol MKLifeBLECentralManagerDelegate <NSObject>

- (void)mokoLifeBleScanNewDevice:(MKLifeBLEDeviceModel *)deviceModel;

@optional

- (void)mokoLifeBleStartScan;

- (void)mokoLifeBleStopScan;

@end

@interface MKLifeBLECentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <MKLifeBLECentralManagerDelegate>delegate;

+ (MKLifeBLECentralManager *)shared;

+ (void)sharedDealloc;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (MKCentralManagerState )centralStatus;

- (MKPeripheralConnectState)connectState;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Connect device function
/// @param peripheral CBPeripheral
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// disconnect
- (void)disconnect;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param resetNum How many data will the communication device return
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
