//
//  CompanyViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "AddressTableViewCell.h"
#import "NSString+Extension.h"

@interface CompanyInfoViewController ()

@end

@implementation CompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    
    self.titles = [NSMutableArray arrayWithArray:@[
                                                   
                                                   @[@" 单位名称",@" 单位电话"],
                                                   
                                                   @[@" 单位地址"],
                                                   
                                                   @[@" 职位级别"],
                                                   
                                                   @[@"月基本薪资",@" 其他收入"]
                
                                                   ]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 1) {
        
        cell = [AddressTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }else{
        
        cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    //右侧文字
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = infoDictionary[@"comp_name"];
        }
        else {
            cell.detailTextLabel.text = infoDictionary[@"comp_mobile"];
        }
    }
    else if (indexPath.section == 1) {
        
        cell.detailTextLabel.text = [NSString appendStringWithProv:infoDictionary[@"comp_prov"] City:infoDictionary[@"comp_city"] andArea:infoDictionary[@"comp_area"] andTown:infoDictionary[@"comp_town"]];
    
    }
    else if (indexPath.section == 2) {
        
        cell.detailTextLabel.text = [[infoDictionary[@"comp_job"] componentsSeparatedByString:@","] lastObject];
    }
    else {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",infoDictionary[@"month_salary"]];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",infoDictionary[@"other_salary"]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return ZHFit(105);
    }
    return ZHFit(54);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = ZHBackgroundColor;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

@end
