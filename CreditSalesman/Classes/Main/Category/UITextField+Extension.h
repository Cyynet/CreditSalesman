//
//  UITextField+Extension.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

+ (instancetype )addFieldWithFrame:(CGRect)frame
                          delegate:(id)delegate;

+ (instancetype )addFieldWithFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate;

@end
