//
//  PDFMyCenterController.m
//  PandaFootball
//
//  Created by Oliver Chen on 16/4/11.
//  Copyright © 2016年 myjoy. All rights reserved.
//

#import "PDFMyCenterController.h"
#import "PDFPCHMacro.h"

#import "MyCenterHeaderView.h"
#import "PDFSpaceView.h"

#import "MyOrderViewController.h"
#import "MyCourseViewController.h"
#import "MyCenterMessageViewController.h"


static const CGFloat kTableViewCellHeight        = 55.0f;

@interface PDFMyCenterController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *navigationTitleLabel;
@property (nonatomic, strong) MyCenterHeaderView *headerView;

@property (nonatomic, strong) NSArray *dataSourceArray;


@end

@implementation PDFMyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PDFColorBackground;
    
    [self.view addSubview:self.navigationTitleLabel];
    
    [self.tableViewHeader addSubview:self.headerView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    CGFloat sectionHeaderHeight = PDFSpaceSmallest;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self.dataSourceArray objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = [(NSArray *)[self.dataSourceArray objectAtIndex:indexPath.section]
                           objectAtIndex:indexPath.row];
    
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.imageView.image = [UIImage imageNamed:[dataDic objectForKey:@"image"]];
    
    cell.textLabel.text = [dataDic objectForKey:@"title"];
    cell.textLabel.font = PDFFontDetailBigger;
    cell.textLabel.textColor = PDFColorTextDetailMoreDeep;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
#ifdef __IPHONE_8_0
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
#endif
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return PDFSpaceSmallest;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PDFSpaceView *spaceView = [[PDFSpaceView alloc] init];
    spaceView.frame = CGRectMake(0, 0, MAIN_WIDTH, PDFSpaceSmallest);
    
    spaceView.backgroundColor = PDFColorBackground;
    
    return spaceView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MyOrderViewController *viewController = [[MyOrderViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        if (indexPath.row == 1) {
            MyCourseViewController *viewController = [[MyCourseViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MyCenterMessageViewController *viewController = [[MyCenterMessageViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - Getters
- (NSArray *)dataSourceArray {
    _dataSourceArray = @[
                         @[
                             @{@"image":@"MyCenterOrder",
                               @"title":@"我的订单"},
                             
                             @{@"image":@"MyCenterCourse",
                               @"title":@"我的球场"}
                             ],
                         @[
                             @{@"image":@"MyCenterInviteTeam",
                               @"title":@"邀请球队"},
                             
                             @{@"image":@"MyCenterInviteFriend",
                               @"title":@"邀请好友"}
                             ],
                         @[
                             @{@"image":@"MyCenterMessage",
                               @"title":@"我的消息"},
                             
                             @{@"image":@"MyCenterSetting",
                               @"title":@"账号设置"},
                             
                             @{@"image":@"MyCenterOther",
                               @"title":@"其他"}
                             ]
                         ];
    return _dataSourceArray;
}

#pragma mark - LazyLoad
- (UILabel *)navigationTitleLabel {
    if (!_navigationTitleLabel) {
        _navigationTitleLabel = [[UILabel alloc] init];
        _navigationTitleLabel.frame = CGRectMake(0, STATUS_BAR_HEIGHT, MAIN_WIDTH, NAVIGATIONBAR_HEIGHT);
        
        _navigationTitleLabel.backgroundColor = [UIColor clearColor];
        _navigationTitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _navigationTitleLabel.text = @"熊猫足球";
        _navigationTitleLabel.textColor = PDFColorWhite;
        _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navigationTitleLabel;
}

- (MyCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MyCenterHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_From_4_7(180) - STATUS_NAV_BAR_HEIGHT);
    }
    return _headerView;
}

@end
