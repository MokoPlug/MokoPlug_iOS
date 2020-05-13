//
//  MKModifyPowerStatusCell.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKModifyPowerStatusCell.h"
#import "MKModifyPowerStatusCellModel.h"

@interface MKModifyPowerStatusCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKModifyPowerStatusCell

+ (MKModifyPowerStatusCell *)initCellWithTableView:(UITableView *)tableView {
    MKModifyPowerStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKModifyPowerStatusCellIdenty"];
    if (!cell) {
        cell = [[MKModifyPowerStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKModifyPowerStatusCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(12.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKModifyPowerStatusCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = _dataModel.msg;
    UIImage *leftImage = (_dataModel.selected ? LOADIMAGE(@"modifyPowerOnSelectedIcon", @"png") : LOADIMAGE(@"modifyPowerOnUnselectedIcon", @"png"));
    self.leftIcon.image = leftImage;
    self.msgLabel.textColor = (_dataModel.selected ? COLOR_NAVIBAR_CUSTOM : RGBCOLOR(128, 128, 128));
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"modifyPowerOnUnselectedIcon", @"png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = RGBCOLOR(128, 128, 128);
        _msgLabel.font = MKFont(14.f);
    }
    return _msgLabel;
}

@end
