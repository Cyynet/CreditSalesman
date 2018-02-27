//
//  UIButton+Extension.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/21.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)


typedef void(^TapButtonActionBlock) (UIButton *button) ;

/**
 *  快速创建文字Button
 *
 *  @param frame           frame
 *  @param title           title
 *  @param backgroundColor 背景颜色
 *  @param titleColor      文字颜色
 *  @param tapAction       回调
 */
+ (instancetype)addCustomButtonWithFrame:(CGRect)frame
                                   title:(NSString *)title
                         backgroundColor:(UIColor *)backgroundColor
                              titleColor:(UIColor *)titleColor
                               tapAction:(TapButtonActionBlock)tapAction;


@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval;   // 可以用这个给重复点击加间隔

@end
