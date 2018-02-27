//
//  UIImageView+Extension.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/21.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

/**
 这里传入二维码的信息,image是加载二维码上方的图片
 */
- (void)creatCode:(NSString *)codeContent;

- (void)showBadgeWithNumber:(NSString *)number;   //显示小红点

- (void)hideBadge;   //隐藏小红点

@end
