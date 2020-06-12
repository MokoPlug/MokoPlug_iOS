//
//  MKEnergyValueCell.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/15.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKEnergyValueCell.h"
#import "MKEnergyValueCellModel.h"

@interface MKEnergyValueCell ()

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@end

@implementation MKEnergyValueCell

+ (MKEnergyValueCell *)initCellWithTableView:(UITableView *)tableView {
    MKEnergyValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKEnergyValueCellIdenty"];
    if (!cell) {
        cell = [[MKEnergyValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKEnergyValueCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKEnergyValueCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.timeLabel.text = SafeStr(_dataModel.timeValue);
    self.valueLabel.text = SafeStr(_dataModel.energyValue);
}

#pragma mark - getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGBCOLOR(128, 128, 128);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = MKFont(14.f);
    }
    return _timeLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.font = MKFont(14.f);
    }
    return _valueLabel;
}

@end
