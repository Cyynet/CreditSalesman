//
//  LoanInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/15.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "LoanInfoViewController.h"
#import "SessionTool.h"

@interface LoanInfoViewController ()

@end

@implementation LoanInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.titles = [NSMutableArray arrayWithObjects:@"身份类型",@"产品类型",@"申请金额",@"申请期限",@"月承受还款额",nil];
    
    //请求数据
    [self requsetServerData];
    
    //组头
    UILabel *timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 54)];
    timeLabel.font = fontSize(14);
    timeLabel.textColor = UIColorWithRGB(0x8988989);
    timeLabel.backgroundColor = ZHBackgroundColor;
    self.tableView.tableHeaderView = timeLabel;
    
}

#pragma mark - 请求数据
- (void)requsetServerData {
    
    NSDictionary *param = @{
                            @"apply_loan_key":self.loanKey
                           };
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetAllLoanInfoOnSaler.spring",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            [SessionTool GetInstance].infoDic = responseObject[@"data"];
            
            ((UILabel *)self.tableView.tableHeaderView).text = [NSString stringWithFormat:@"    申请时间：%@",[SessionTool GetInstance].infoDic[@"insert_date"]];
            
            [self.tableView reloadData];
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    
    if (indexPath.row == 0) {
    
        if ([infoDictionary[@"cust_type"] isEqualToString:@"1"]) {
             cell.detailTextLabel.text = @"工薪族";
        }else if ([infoDictionary[@"cust_type"] isEqualToString:@"2"]){
             cell.detailTextLabel.text = @"企业主";
        }
    }else if (indexPath.row == 1) {
        cell.detailTextLabel.text = [[infoDictionary[@"loan_type"] componentsSeparatedByString:@","] lastObject];
    }else if (indexPath.row == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",infoDictionary[@"loan_amount"]];
    }else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@期",infoDictionary[@"loan_term"]];
    }else  {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",infoDictionary[@"month_pay_amt"]];
    }
    return cell;
}


@end
