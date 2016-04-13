//
//  PDFMyCenterController.m
//  PandaFootball
//
//  Created by Oliver Chen on 16/4/11.
//  Copyright © 2016年 myjoy. All rights reserved.
//

#import "PDFMyCenterController.h"
#import "PDFPCHMacro.h"

static const CGFloat kTableviewCellHeight        = 55.0f;

@interface PDFMyCenterController() <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation PDFMyCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setNavigationTitleWhite:@"熊猫主球"];
    
    self.view.backgroundColor = PDFColorBackground;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatusBarBlank];
    //设置navigation为不透明
    self.navigationController.navigationBar.translucent = NO;
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
    NSDictionary *dataDic=[(NSArray *)[self.dataSourceArray objectAtIndex:indexPath.section]
                           objectAtIndex:indexPath.row];
    
    static NSString *identify = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.imageView.image = [UIImage imageNamed:[dataDic objectForKey:@"image"]];
    
    cell.textLabel.text = [dataDic objectForKey:@"title"];
    cell.textLabel.font = PDFFontDetailDefault;
    cell.textLabel.textColor = PDFColorTextDetailDefault;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableviewCellHeight;
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
    else {
        return PDFSpaceSmallest;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *spaceView = [[UIView alloc] init];
    spaceView.frame = CGRectMake(0, 0, MAIN_WIDTH, PDFSpaceSmallest);
    
    spaceView.backgroundColor = PDFColorBackground;
    
    return spaceView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Getters
- (NSMutableArray *)dataSourceArray {
    _dataSourceArray = (NSMutableArray *)@[
                                           @[
                                               @{@"image":@"MyCenterCreate",
                                                 @"title":@"创建球队"},
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
                                               ],
                                           @[
                                               @{@"image":@"MyCenterEvaluate",
                                                 @"title":@"评价一下"}
                                               ]
                                           ];
    return _dataSourceArray;
}

@end
