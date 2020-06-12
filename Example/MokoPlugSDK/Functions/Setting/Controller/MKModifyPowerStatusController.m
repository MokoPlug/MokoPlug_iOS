//
//  MKModifyPowerStatusController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/13.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKModifyPowerStatusController.h"

#import "MKModifyPowerStatusCell.h"
#import "MKModifyPowerStatusCellModel.h"

@interface MKModifyPowerStatusController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKModifyPowerStatusController

- (void)dealloc {
    NSLog(@"MKModifyPowerStatusController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableViewDatas];
    [self readPowerOnStatus];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface configPowerOnSwitchStatus:indexPath.row sucBlock:^{
        [[MKHudManager share] hide];
        self.index = indexPath.row;
        [self reloadCellWithIndex];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKModifyPowerStatusCell *cell = [MKModifyPowerStatusCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - interface
- (void)readPowerOnStatus {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKLifeBLEInterface readPowerOnSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        self.index = [returnData[@"result"][@"switchStatus"] integerValue];
        [self reloadCellWithIndex];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark -
- (void)reloadCellWithIndex {
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKModifyPowerStatusCellModel *model = self.dataList[i];
        model.selected = (i == self.index);
    }
    [self.tableView reloadData];
}

- (void)loadTableViewDatas {
    MKModifyPowerStatusCellModel *offModel = [[MKModifyPowerStatusCellModel alloc] init];
    offModel.msg = @"Switch off";
    [self.dataList addObject:offModel];
    
    MKModifyPowerStatusCellModel *onModel = [[MKModifyPowerStatusCellModel alloc] init];
    onModel.msg = @"Switch on";
    [self.dataList addObject:onModel];
    
    MKModifyPowerStatusCellModel *revertModel = [[MKModifyPowerStatusCellModel alloc] init];
    revertModel.msg = @"Revert to last status";
    [self.dataList addObject:revertModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"Modify power on status";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
