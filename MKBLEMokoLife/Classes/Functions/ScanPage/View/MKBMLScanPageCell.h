//
//  MKBMLScanPageCell.h
//  MKBLEMokoLife_Example
//
//  Created by aa on 2021/4/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBMLDeviceModel;
@interface MKBMLScanPageCell : MKBaseCell

@property (nonatomic, strong)MKBMLDeviceModel *dataModel;

+ (MKBMLScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
