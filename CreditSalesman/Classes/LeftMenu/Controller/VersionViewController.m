//
//  VersionViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/21.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "VersionViewController.h"
#import "ZHVersionTableViewCell.h"
#import "ZHVersionModel.h"
#import <MJExtension.h>
#import "NSString+Extension.h"
@interface VersionViewController ()


@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"版本记录";
}

- (void)requsetDataList {
    
    NSDictionary *params = @{
                             @"app_type":@"I",
                             @"ver_name":@"saler",
                             @"pageIndex":@"1",
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetVersionLogs.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            self.requestResults = [ZHVersionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            
            //刷新列表
            [self.tableView reloadData];
            
            //取消没有数据的状态
            [self.tableView.mj_footer resetNoMoreData];
            
            //如果一页就加载完毕所有数据，就隐藏上拉刷新
            if ([responseObject[@"data"][@"pageindex"] integerValue] >= [responseObject[@"data"][@"totalpage"] integerValue]) {
                
                self.tableView.mj_footer.hidden = YES;
            }

        }
        //结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
        //结束下拉刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHVersionTableViewCell * cell = [ZHVersionTableViewCell dequeueReusableCellWithTableView:tableView Identifier:@"version"];
    
    [cell settingCellWithValue:self.requestResults IndexPath:indexPath];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = kScreenWidth- 2 * ZHFit(10);
    CGFloat textHight = 0;
    if (self.requestResults.count >indexPath.row) {
        
        ZHVersionModel * model = [self.requestResults objectAtIndex:indexPath.row];
        NSString * str = [NSString stringWithFormat:@" 更新记录\n\n%@",model.ver_text];
        textHight = [NSString computeTextSizeHeight:str Range:CGSizeMake(width-ZHFit(40), MAXFLOAT)].height;
    }
    return ZHFit(58) + textHight + ZHFit(40) + 20;
    
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
                             @"app_type":@"I",
                             @"ver_name":@"client",
                             @"pageIndex":@"1",
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetAllLoanByStateOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        //字典转模型
        NSArray *moreResults = [ZHVersionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        
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
