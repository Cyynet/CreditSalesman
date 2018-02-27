//
//  BaseTableViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "SessionTool.h"

#define infoDictionary [SessionTool GetInstance].infoDic

@interface BaseTableViewController : UIViewController

/** tableView */
@property (strong, nonatomic) UITableView *tableView;

/** 标题数组 */
@property (strong, nonatomic) NSMutableArray *titles;

/** 进件号 */
@property (copy, nonatomic)  NSString *loanKey;

@end
