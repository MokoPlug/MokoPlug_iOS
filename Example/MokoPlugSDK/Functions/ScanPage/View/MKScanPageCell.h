//
//  MKScanPageCell.h
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/6.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKScanPageCell : MKBaseCell

@property (nonatomic, strong)MKLifeBLEDeviceModel *dataModel;

+ (MKScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
