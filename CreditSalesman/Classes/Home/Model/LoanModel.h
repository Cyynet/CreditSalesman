//
//  LoanModel.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List;

@interface LoanModel : NSObject

@property (nonatomic, assign) NSInteger totalpage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<List *> *list;

@property (nonatomic, assign) NSInteger pageindex;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface List : NSObject

/** 首付*/
@property (copy,nonatomic)  NSString *rn;

/** 联系电话*/
@property(nonatomic,copy)   NSString * mobile;

/** 订单编号*/
@property(nonatomic,copy)   NSString * apply_loan_key;

/** 订单创建时间*/
@property(nonatomic,copy)   NSString * insert_date;

/** 贷款状态*/
@property(nonatomic,copy)   NSString * audit_status;

/** 贷款金额*/
@property(nonatomic,copy)   NSString * loan_amount;

/** 批核金额*/
@property(nonatomic,copy)   NSString * audit_amount;

/** 贷款产品期数*/
@property(nonatomic,copy)   NSString * loan_term;

/** 批核期数*/
@property(nonatomic,copy)   NSString * audit_term;

/** 贷款产品类型 */
@property(nonatomic,copy)   NSString *loan_type;

/** 批核类型*/
@property (nonatomic,copy)  NSString *audit_type;

/** 客户姓名 */
@property (nonatomic,copy)  NSString *cust_name;

/** 客户编号*/
@property(nonatomic,copy)   NSString * cust_no;

@end

