//
//  UILabel+Extension.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/30.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 *  快速创建Label
 *
 *  @param frame         frame
 *  @param title         文字
 *  @param titleColor    文字颜色
 *  @param font          字体
 */

+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font;

/**快速创建Label  稍后计算frame*/
+ (instancetype)addLabelWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font;

/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor;

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

/**
 *  设置下划线
 @param color 下划线颜色
 */
- (void)setBottomLineWithColor:(UIColor *)color;

@end
