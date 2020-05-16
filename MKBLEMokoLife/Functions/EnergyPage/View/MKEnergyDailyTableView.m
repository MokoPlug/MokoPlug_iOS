//
//  MKEnergyDailyTableView.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/15.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKEnergyDailyTableView.h"
#import "MKEnergyTableHeaderView.h"
#import "MKEnergyValueCell.h"
#import "MKEnergyValueCellModel.h"

@interface MKEnergyDailyTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *dailyTableView;

@property (nonatomic, strong)MKEnergyTableHeaderView *dailyTableHeader;

@property (nonatomic, strong)MKEnergyTableHeaderViewModel *dailyHeaderModel;

@property (nonatomic, strong)NSMutableArray *dailyList;

@property (nonatomic, assign)CGFloat pulseConstant;

@end

@implementation MKEnergyDailyTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dailyTableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dailyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dailyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKEnergyValueCell *cell = [MKEnergyValueCell initCellWithTableView:tableView];
    cell.dataModel = self.dailyList[indexPath.row];
    return cell;
}

#pragma mark - public method

- (void)updateEnergyDatas:(NSArray *)energyList pulseConstant:(NSString *)pulseConstant {
    self.pulseConstant = [pulseConstant floatValue];
    if (self.pulseConstant == 0) {
        return;
    }
    [self.dailyList removeAllObjects];
    NSUInteger totalValue = 0;
    for (NSInteger i = energyList.count - 1; i >= 0; i --) {
        NSDictionary *dic = energyList[i];
        MKEnergyValueCellModel *model = [[MKEnergyValueCellModel alloc] init];
        NSString *timeValue = [NSString stringWithFormat:@"%ld",[dic[@"index"] integerValue] + 1];
        model.timeValue = (timeValue.length == 1 ? [@"0" stringByAppendingString:timeValue] : timeValue);
        model.energyValue = dic[@"rotationsNumber"];
        totalValue += [dic[@"rotationsNumber"] integerValue];
        [self.dailyList addObject:model];
    }
    [self.dailyTableView reloadData];
    self.dailyHeaderModel.energyValue = [NSString stringWithFormat:@"%2.f",(totalValue * 1.f) / self.pulseConstant];
    NSString *date = [self fetchCurrentDate];
    NSString *tempHour = @"00";
    if (self.dailyList.count > 0) {
        MKEnergyValueCellModel *model = self.dailyList.firstObject;
        tempHour = model.timeValue;
    }
    self.dailyHeaderModel.dateMsg = [NSString stringWithFormat:@"00:00 to %@:00,%@",tempHour,date];
    [self.dailyTableHeader setViewModel:self.dailyHeaderModel];
}

#pragma mark - getter
- (MKBaseTableView *)dailyTableView {
    if (!_dailyTableView) {
        _dailyTableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _dailyTableView.backgroundColor = COLOR_WHITE_MACROS;
        _dailyTableView.delegate = self;
        _dailyTableView.dataSource = self;
        _dailyTableView.tableHeaderView = self.dailyTableHeader;
    }
    return _dailyTableView;
}

- (NSMutableArray *)dailyList {
    if (!_dailyList) {
        _dailyList = [NSMutableArray array];
    }
    return _dailyList;
}

- (MKEnergyTableHeaderView *)dailyTableHeader {
    if (!_dailyTableHeader) {
        _dailyTableHeader = [[MKEnergyTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230.f)];
        _dailyTableHeader.viewModel = self.dailyHeaderModel;
    }
    return _dailyTableHeader;
}

- (MKEnergyTableHeaderViewModel *)dailyHeaderModel {
    if (!_dailyHeaderModel) {
        _dailyHeaderModel = [[MKEnergyTableHeaderViewModel alloc] init];
        _dailyHeaderModel.energyValue = @"0";
        _dailyHeaderModel.timeMsg = @"Hour";
    }
    return _dailyHeaderModel;
}

- (NSString *)fetchCurrentDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormat stringFromDate:[NSDate date]];
    return date;
}

@end
