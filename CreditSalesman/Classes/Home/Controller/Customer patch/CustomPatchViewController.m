//
//  CustomPatchViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/19.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "CustomPatchViewController.h"
#import "UIAlertViewTool.h"
#import "MainScrollViewController.h"
#import "CustomPatchCell.h"
#import "LoanModel.h"

@interface CustomPatchViewController ()<OrderTableViewCellDelegate>

/** 提示文字label */
@property (strong, nonatomic)  UILabel *messageLabel;

@end

@implementation CustomPatchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requsetDataListCustom];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.messageLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户补件";
}

- (void)requsetDataListCustom {
    
    self.pageIndex = 1;
    
    NSDictionary *params = @{
                             @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
                             @"audit_status":@"1,6",
                             @"pageIndex":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetAllLoanByStateOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            //1.显示订单号可复制
            [self showLabelMessage];
            
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

#pragma mark - 显示提示框

- (void)showLabelMessage {
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 - 34, self.view.width, 34)];
    messageLabel.text = @"     长按订单编号可复制";
    messageLabel.font = fontSize(12);
    messageLabel.textColor = UIColorWithRGB(0x959595);
    messageLabel.backgroundColor = UIColorWithRGB(0xfff2c8);
    self.messageLabel = messageLabel;
    [self.navigationController.view insertSubview:messageLabel belowSubview:self.navigationController.navigationBar];
    
    // 动画
    [UIView animateWithDuration:1.0 animations:^{
        // 往下走
        messageLabel.transform = CGAffineTransformMakeTranslation(0, messageLabel.height);
        
    } completion:^(BOOL finished) {
        // 停一会回去
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            messageLabel.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            [messageLabel removeFromSuperview];
        }];
    }];
}

#pragma mark - Table view dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView cellType:UITableViewCellTypeCustomPatch];
    
    cell.loanModel = self.requestResults[indexPath.row];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - CustomPatchCell delegate

- (void)clickCustomBtnWithLoanKey:(NSString *)loanKey Btn:(UIButton *)btn{
    
    UIView *v = [btn superview];//获取父类view
    UIView *v1 = [[v superview] superview];
    OrderTableViewCell *cell = (OrderTableViewCell *)[v1 superview];//获取cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];//获取cell对应的section
    
    List *model = self.requestResults[indexPath.row];
    
    MainScrollViewController *VC = [[MainScrollViewController alloc] init];
    VC.loanKey = model.apply_loan_key;
    VC.contacts_mobile = model.mobile;
    VC.cust_no = model.cust_no;
    VC.loan_type = [[model.loan_type componentsSeparatedByString:@","] lastObject];
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ZHFit(193) + 20;
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
                             @"audit_status":@"1,6",
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
