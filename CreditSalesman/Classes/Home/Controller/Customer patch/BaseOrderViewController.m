//
//  BaseOrderViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BaseOrderViewController.h"

@interface BaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseOrderViewController

- (NSMutableArray *)requestResults {
    
    if (!_requestResults) {
        
        _requestResults = [NSMutableArray array];
    }
    return _requestResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tableView
    [self setupTableView];
    
    //添加刷新控件
    [self setupRefresh];
}

#pragma  mark - 下拉刷新
- (void)setupRefresh {
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetDataList)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    //上拉刷新
   self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requsetMoreData)];
}

- (void)requsetDataList {
    
}

- (void)requsetMoreData {
    
}

- (void)setupTableView {
    
    self.view.backgroundColor = ZHBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = ZHBackgroundColor;
    tableView.frame = self.view.bounds;
    tableView.height = self.view.height - 64;
    tableView.dataSource = self;
    tableView.delegate  = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - Table view dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 控制footer是否隐藏
    self.tableView.mj_footer.hidden = self.requestResults.count == 0;
    
    return self.requestResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView cellType:UITableViewCellTypeCustomPatch];
    
    cell.loanModel = self.requestResults[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ZHFit(136) + 20;
}

#pragma mark - Scrow view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

@end
