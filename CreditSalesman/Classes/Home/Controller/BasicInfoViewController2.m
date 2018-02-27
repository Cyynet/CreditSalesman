//
//  BasicInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/30.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BasicInfoViewController2.h"

@interface BasicInfoViewController2 ()

@end

@implementation BasicInfoViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基本信息";
    
    self.titles = [NSMutableArray arrayWithArray:@[
                                                   
                                                   @[@"*婚姻状况",@"*学历"],
                                                   
                                                   @[@"  QQ",@"  微信"],
                                                   
                                                   @[@"*居住信息"],
                                                   
                                                   @[@"*联系人"]
                                                   
                                                   ]];
    
}

- (void)requestData{
    
    NSDictionary *params = @{
    
                             };
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetBaseInfoByLoanKey.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            self.dataDictionary = responseObject[@"data"];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    if ([cell.textLabel.text containsString:@"*"]) {
        
        [cell.textLabel setTextWithColor:ZHThemeColor];
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([self.mar_status_name isEqualToString:@"请选择"]) {
                
                self.mar_status_name = [[self.dataDictionary[@"marstatus"] componentsSeparatedByString:@","] lastObject];
                self.mar_status = self.dataDictionary[@"marstatus"];
            }
            
            cell.detailTextLabel.text = !NULLString(self.mar_status_name) ? self.mar_status_name : @"请选择";
            self.mar_status_name = cell.detailTextLabel.text;
            cell.accessoryView = ArrowView;
            
        }
        
        if (indexPath.row == 1) {
            
            cell.detailTextLabel.text = !NULLString(self.education_name) ? self.education_name : @"请选择";
            self.education_name = cell.detailTextLabel.text;
            cell.accessoryView = ArrowView;
        }
    }
    if (indexPath.section == 1 ) {
        
        if (indexPath.row == 0) {
            
            _qqTextField = [UITextField addFieldWithFrame:textFieldFrame delegate:self];
            _qqTextField.text = !NULLString(self.qq) ? self.qq :self.dataDictionary[@"qq"] ;
            self.qq = _qqTextField.text;
            _qqTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:_qqTextField];
        }
        
        if (indexPath.row == 1) {
            
            _wxTextField = [UITextField addFieldWithFrame:textFieldFrame delegate:self];
            _wxTextField.text = !NULLString(self.wx) ? self.wx :self.dataDictionary[@"wx"];
            self.wx = _wxTextField.text;
            [cell.contentView addSubview:_wxTextField];
         }
     }
    
    if (indexPath.section == 2 ) {
        
        self.fullAddress = [self appendStringWithProv:self.dataDictionary[@"liveprov"] City:self.dataDictionary[@"livecity"] andArea:self.dataDictionary[@"livearea"] andTown:self.dataDictionary[@"livetown"]];
        
        cell.detailTextLabel.text = !NULLString(self.fullAddress) ? self.fullAddress : @"请完善";
        self.fullAddress = cell.detailTextLabel.text;
        cell.accessoryView = ArrowView;
        
    }
    
    if (indexPath.section == 3 ) {
    
        self.contacts = self.dataDictionary[@"contract"];
        
        cell.detailTextLabel.text = !NULLString(self.contacts) ? self.contacts : @"请完善";
        self.contacts = cell.detailTextLabel.text;
        cell.accessoryView = ArrowView;
    }
    
    return cell;
}

/**
 @return 返回省市区的中文名
 */
- (NSString *)appendStringWithProv:(NSString *)prov City:(NSString *)city andArea:(NSString *)area andTown:(NSString *)town{
    
    //如果请求下来数据为空,就直接返回nil
    if (NULLString(prov)) return nil;
    
    NSString *str1 = [[prov componentsSeparatedByString:@","] firstObject];
    NSString *str2 = [[city componentsSeparatedByString:@","] firstObject];
    NSString *str3 = [[area componentsSeparatedByString:@","] firstObject];
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@",str1,str2,str3,town];
}


@end
