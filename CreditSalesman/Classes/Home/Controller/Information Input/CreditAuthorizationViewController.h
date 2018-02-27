//
//  CreditAuthorizationViewController.h
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/25.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditAuthorizationViewController : UIViewController

@property (nonatomic,copy) void(^infoCompleteBlock)(BOOL);

@property (nonatomic, copy) NSArray  * apply_loan_key;

@end
