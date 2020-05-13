//
//  MKSettingController.m
//  MKBLEMokoLife
//
//  Created by aa on 2020/5/11.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKSettingController.h"

#import "MKSettingPageCell.h"
#import "MKSettingButtonCell.h"

#import "MKSettingPageCellModel.h"

#import "MKDeviceInfoController.h"

@interface MKSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@end

@implementation MKSettingController

- (void)dealloc {
    NSLog(@"MKSettingController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    MKDeviceInfoController *vc = [[MKDeviceInfoController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    }
    if (section == 1) {
        return 50.f;
    }
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *section0Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.f)];
        section0Header.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (40.f - MKFont(12.f).lineHeight) / 2, kScreenWidth - 2 * 15.f, MKFont(12.f).lineHeight)];
        sectionLabel.textColor = RGBCOLOR(128, 128, 128);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = MKFont(12.f);
        sectionLabel.text = @"General settings";
        [section0Header addSubview:sectionLabel];
        
        return section0Header;
    }
    if (section == 1) {
        UIView *section1Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
        section1Header.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, (50.f - MKFont(12.f).lineHeight) / 2, kScreenWidth - 2 * 15.f, MKFont(12.f).lineHeight)];
        sectionLabel.textColor = RGBCOLOR(128, 128, 128);
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        sectionLabel.font = MKFont(12.f);
        sectionLabel.text = @"Advanced settings";
        [section1Header addSubview:sectionLabel];
        
        return section1Header;
    }
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20.f)];
    sectionHeader.backgroundColor = RGBCOLOR(242, 242, 242);
    return sectionHeader;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        MKSettingButtonCell *cell = [MKSettingButtonCell initCellWithTableView:tableView];
        cell.msg = self.section2List[indexPath.row];
        return cell;
    }
    MKSettingPageCell *cell = [MKSettingPageCell initCellWithTableView:tableView];
    if (indexPath.section == 0) {
        cell.dataModel = self.section0List[indexPath.row];
    }else {
        cell.dataModel = self.section1List[indexPath.row];
    }
    return cell;
}

#pragma mark - UI
- (void)loadTableDatas {
#pragma mark - section0数据源
    MKSettingPageCellModel *nameModel = [[MKSettingPageCellModel alloc] init];
    nameModel.leftMsg = @"Modify device name";
    [self.section0List addObject:nameModel];
    
    MKSettingPageCellModel *powerModel = [[MKSettingPageCellModel alloc] init];
    powerModel.leftMsg = @"Modify power on status";
    [self.section0List addObject:powerModel];
    
    MKSettingPageCellModel *updateModel = [[MKSettingPageCellModel alloc] init];
    updateModel.leftMsg = @"Check update";
    [self.section0List addObject:updateModel];
    
#pragma mark - section1数据源
    MKSettingPageCellModel *broadcastModel = [[MKSettingPageCellModel alloc] init];
    broadcastModel.leftMsg = @"Broadcast frequency(100ms)";
    [self.section1List addObject:broadcastModel];
    
    MKSettingPageCellModel *overloadValueModel = [[MKSettingPageCellModel alloc] init];
    overloadValueModel.leftMsg = @"Overload value(W)";
    [self.section1List addObject:overloadValueModel];
    
    MKSettingPageCellModel *reportIntervalModel = [[MKSettingPageCellModel alloc] init];
    reportIntervalModel.leftMsg = @"Power reporting Interval(min)";
    [self.section1List addObject:reportIntervalModel];
    
    MKSettingPageCellModel *notificationModel = [[MKSettingPageCellModel alloc] init];
    notificationModel.leftMsg = @"Power change notification(%)";
    [self.section1List addObject:notificationModel];
    
    MKSettingPageCellModel *energyModel = [[MKSettingPageCellModel alloc] init];
    energyModel.leftMsg = @"Energy consumption(KWh)";
    [self.section1List addObject:energyModel];
    
    [self.section2List addObject:@"Reset Device"];
    [self.section2List addObject:@"Disconnect"];
    
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.custom_naviBarColor = COLOR_NAVIBAR_CUSTOM;
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.rightButton setImage:LOADIMAGE(@"detailIcon", @"png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (UIView *)footerView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.f)];
    footerView.backgroundColor = RGBCOLOR(242, 242, 242);
    return footerView;
}

@end
