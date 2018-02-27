//
//  SignViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/25.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.height = self.view.height - 64 - 40;
}

- (void)requsetDataList {
    
    self.pageIndex = 1;
    
    NSDictionary *params = @{
                             @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
                             @"audit_status":self.searchText,
                             @"pageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetAllLoanByStateOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            //字典转模型
            LoanModel *requestModel = [LoanModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            self.requestResults = (NSMutableArray *)requestModel.list;
            
            //储存总页数
            self.totalPage = requestModel.totalpage;
            
            //刷新页面
            [self.tableView reloadData];
            
            //取消没有数据的状态
            [self.tableView.mj_footer resetNoMoreData];
            
            //如果一页就加载完毕所有数据，就隐藏上拉刷新
            if (requestModel.pageindex >= requestModel.totalpage) {
                self.tableView.mj_footer.hidden = YES;
            }
        }
        //结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}

#pragma mark - Table view dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView cellType:UITableViewCellTypeDefault];
    
    cell.loanModel = self.requestResults[indexPath.row];
    
    return cell;
}

#pragma mark - 请求服务器获取数据(上拉加载)
- (void)requsetMoreData {
    
    //页数+1
    self.pageIndex ++;
    
    //当当前页数大于总页数，显示没有数据
    if (self.pageIndex > self.totalPage) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    
    NSDictionary *params = @{
                             @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
                             @"audit_status":self.searchText,
                             @"pageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetAllLoanByStateOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        //字典转模型
        NSArray *moreResults = [LoanModel mj_objectWithKeyValues:responseObject[@"data"]].list;
        
        //将新数据加载到原来数据的后面
        [self.requestResults addObjectsFromArray:moreResults];
        
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}



@end
