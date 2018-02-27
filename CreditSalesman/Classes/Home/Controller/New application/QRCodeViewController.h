//
//  QRCodeViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/13.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

/** 产品类型 */
@property (copy, nonatomic)  NSString *product_name;

/** 支持期数 */
@property (copy, nonatomic)  NSString *productTerm;

/** 借款金额 */
@property (copy, nonatomic)  NSString *loanMoney;

/** 二维码 */
@property (copy, nonatomic)  NSString *codeStr;

/** 剩余时间 */
@property (copy, nonatomic)  NSString *dic_value;

@end
