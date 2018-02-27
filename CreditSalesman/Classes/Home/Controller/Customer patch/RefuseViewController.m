//
//  RefuseViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "RefuseViewController.h"
#import "SearchBar.h"
@interface RefuseViewController ()<UITextFieldDelegate>

/** 是否去搜索请求的标记 */
@property (assign, nonatomic)  BOOL isSearch;

/** 搜索框 */
@property (strong, nonatomic)  SearchBar *searBar;

@end

@implementation RefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.height = self.view.height - 64 - 40;
    
    if (self.showSearchBar) {
        
        self.title = @"审批拒绝件";
        
        SearchBar *searBar = [SearchBar searchBar];
        searBar.frame =  CGRectMake(30, 20, self.view.width - 60, 32);
        searBar.delegate = self;
        self.searBar = searBar;
        [self.view addSubview:searBar];
        
        self.tableView.y = searBar.bottom;
    }
}

//监听手机键盘点击搜索的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //判断是否有输入,有值的话去请求服务器
    if (textField.text.length) {
        
        self.isSearch = YES;
        //请求数据(模糊查询)
        [self requsetDataList];
    }
    [self.view endEditing:YES];
    return YES;
}

- (void)requsetDataList {
    
    self.pageIndex = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  
              @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
              @"audit_status":@"5,11",
              @"pageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
              @"pageSize":@"5"
              }];
    
    if (self.isSearch) {
        
        NSDictionary *dict = @{
                               @"other_param":self.searBar.text
                               };
        //添加到上一个字典里
        [params addEntriesFromDictionary:dict];
    }
    
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

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ZHFit(165);
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  
              @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
              @"audit_status":@"5,11",
              @"pageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
              @"pageSize":@"5"
              }];
    
    if (self.isSearch) {
        
        NSDictionary *dict = @{
                               @"other_param":self.searBar.text
                              };
        //添加到上一个字典里
        [params addEntriesFromDictionary:dict];
    }
    
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
