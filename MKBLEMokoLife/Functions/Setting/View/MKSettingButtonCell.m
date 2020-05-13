//
//  MKSettingButtonCell.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKSettingButtonCell.h"

@interface MKSettingButtonCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKSettingButtonCell

+ (MKSettingButtonCell *)initCellWithTableView:(UITableView *)tableView {
    MKSettingButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKSettingButtonCellIdenty"];
    if (!cell) {
        cell = [[MKSettingButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKSettingButtonCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

- (void)setMsg:(NSString *)msg {
    _msg = nil;
    _msg = msg;
    self.msgLabel.text = SafeStr(_msg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = RGBCOLOR(128, 128, 128);
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

@end
