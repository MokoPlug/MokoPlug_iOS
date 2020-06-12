//
//  MKScanSearchButton.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanSearchButton.h"

@interface MKScanSearchButton()

/**
 button的标题
 */
@property (nonatomic, strong)UILabel *titleLabel;

/**
 搜索条件
 */
@property (nonatomic, strong)UILabel *searchLabel;

/**
 清除搜索条件
 */
@property (nonatomic, strong)UIButton *clearButton;

@end

@implementation MKScanSearchButton

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.searchLabel];
        [self addSubview:self.clearButton];
        [self addTapAction:self selector:@selector(searchButtonPressed)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
    }];
}

#pragma mark - Private method

- (void)clearButtonPressed{
    [self.titleLabel setHidden:NO];
    [self.searchLabel setHidden:YES];
    [self.clearButton setHidden:YES];
    if (self.clearSearchConditionsBlock) {
        self.clearSearchConditionsBlock();
    }
}

- (void)searchButtonPressed{
    if (self.searchButtonPressedBlock) {
        self.searchButtonPressedBlock();
    }
}

#pragma mark - Public method

- (void)setSearchConditions:(NSMutableArray *)searchConditions{
    _searchConditions = nil;
    _searchConditions = searchConditions;
    if ([_searchConditions containsObject:@"-100dBm"]) {
        [_searchConditions removeObject:@"-100dBm"];
    }
    if (!ValidArray(_searchConditions)) {
        [self.titleLabel setHidden:NO];
        [self.searchLabel setHidden:YES];
        [self.clearButton setHidden:YES];
        return;
    }
    [self.titleLabel setHidden:YES];
    [self.searchLabel setHidden:NO];
    NSString *title = @"";
    for (NSString *string in _searchConditions) {
        title = [title stringByAppendingString:[NSString stringWithFormat:@";%@",string]];
    }
    [self.searchLabel setText:[title substringFromIndex:1]];
    [self.clearButton setHidden:NO];
}

#pragma mark - setter & getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(128, 128, 128);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = MKFont(12.f);
        _titleLabel.text = @"Edit Filter";
    }
    return _titleLabel;
}

- (UILabel *)searchLabel{
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textColor = DEFAULT_TEXT_COLOR;
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.font = MKFont(15.f);
    }
    return _searchLabel;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:LOADIMAGE(@"clearButtonIcon", @"png") forState:UIControlStateNormal];
        [_clearButton addTapAction:self selector:@selector(clearButtonPressed)];
    }
    return _clearButton;
}

@end
