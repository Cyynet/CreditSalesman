//
//  ZHProgressModel.h
//  CreditSalesman
//
//  Created by zhph on 2017/5/3.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHProgressModel : NSObject

/*ID*/
@property(nonatomic,strong)NSString * ID;
/*loan_state 状态*/
@property(nonatomic,strong)NSString * loan_state;
/*loan_result 结果*/
@property(nonatomic,strong)NSString * loan_result;
/*loan_result 日期*/
@property(nonatomic,strong)NSString * insert_date;

@end
