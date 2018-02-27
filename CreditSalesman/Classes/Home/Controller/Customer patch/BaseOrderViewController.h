//
//  BaseOrderViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "OrderTableViewCell.h"
#import "LoanModel.h"

@interface BaseOrderViewController : UIViewController

/** tableView */
@property (strong, nonatomic)  UITableView *tableView;

/** 返回结果 */
@property (strong, nonatomic)  NSMutableArray *requestResults;

/** 当前页数 */
@property (assign, nonatomic)  NSInteger pageIndex;

/** 总页数 */
@property (nonatomic, assign)  NSInteger totalPage;

@end
