//
//  CorporateInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/5/12.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "CorporateInfoViewController.h"
#import "AddressTableViewCell.h"
#import "NSString+Extension.h"

@interface CorporateInfoViewController ()

@end

@implementation CorporateInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    
    self.titles = [NSMutableArray arrayWithArray:@[
                                                   
                                                   @[@" 企业全称",@" 单位电话",@" 房东电话"],
                                                   
                                                   @[@" 执照时间",@" 占股比例",@" 月收入"],
                                                   
                                                   @[@" 企业地址"],
                                                   
                                                   ]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 2) {
        
        cell = [AddressTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }else{
        
        cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    //右侧文字
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = infoDictionary[@"comp_name"];
        }else if (indexPath.row == 1) {
            cell.detailTextLabel.text = infoDictionary[@"comp_mobile"];
        }else {
            cell.detailTextLabel.text = infoDictionary[@"landlord_mobile"];
        }
    }
    else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = infoDictionary[@"register_date"];
        }else if (indexPath.row == 1) {
            cell.detailTextLabel.text = infoDictionary[@"stock_rate"];
        }else {
            cell.detailTextLabel.text = infoDictionary[@"month_salary"];
        }
    }
    else {
        
        cell.detailTextLabel.text = [NSString appendStringWithProv:infoDictionary[@"comp_prov"] City:infoDictionary[@"comp_city"] andArea:infoDictionary[@"comp_area"] andTown:infoDictionary[@"comp_town"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
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
