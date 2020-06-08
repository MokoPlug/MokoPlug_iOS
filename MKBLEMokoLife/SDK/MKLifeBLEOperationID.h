
typedef NS_ENUM(NSInteger, mk_taskOperationID) {
    mk_defaultTaskOperationID,
    
#pragma mark - 读取
    mk_readDeviceNameOperation,
    mk_readAdvIntervalOperation,
    mk_readSwitchStatusOperation,
    mk_readPowerOnSwitchStatusOperation,
    mk_readLoadStatusOperation,
    mk_readOverloadProtectionValueOperation,
    mk_readVCPValueOperation,
    mk_readAccumulatedEnergyOperation,
    mk_readCountdownValueOperation,
    mk_readFirmwareVersionOperation,
    mk_readMacAddressOperation,
    mk_readEnergyStorageParametersOperation,
    mk_readHistoricalEnergyOperation,
    mk_readOverLoadStatusOperation,
    mk_readEnergyDataOfTodayOperation,
    mk_readPulseConstantOperation,
    
#pragma mark - 设置
    mk_configDeviceNameOperation,
    mk_configAdvIntervalOperation,
    mk_configSwitchStatusOperation,
    mk_configPowerOnSwitchStatusOperation,
    mk_configOverloadProtectionValueOperation,
    mk_resetAccumulatedEnergyOperation,
    mk_configCountdownValueOperation,
    mk_resetFactoryOperation,
    mk_configEnergyStorageParametersOperation,
    mk_configDeviceDateOperation,
};
