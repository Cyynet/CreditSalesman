//
//  BaseTableViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseTableViewController

- (NSMutableArray *)titles {
    
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建tableView
    [self setupTableView];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor = ZHBackgroundColor;
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate  = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    //去掉多余的表格线
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)(self.titles[section])).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ZHFit(54);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    //如果tableView只有一组
    if ([tableView numberOfSections] == 1) {
        
        index = self.titles.count - 1;
    }else{
        
        index = ((NSMutableArray *)self.titles[indexPath.section]).count - 1;
    }
    //让它的分割线左对齐
    if (indexPath.row == index) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

#pragma mark - Scrow view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

@end
