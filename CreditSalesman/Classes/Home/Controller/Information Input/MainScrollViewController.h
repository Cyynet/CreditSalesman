//
//  ScrollViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/15.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScrollViewController : UIViewController

/** 进件号 */
@property (copy, nonatomic)  NSString *loanKey;

/** 联系电话*/
@property(nonatomic,copy)   NSString * contacts_mobile;

/** 客户编号*/
@property(nonatomic,copy)   NSString * cust_no;

/** 贷款产品类型 */
@property(nonatomic,copy)   NSString *loan_type;

@end
