//
//  UILabel+Extension.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/30.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "UILabel+Extension.h"
#import <CoreText/CoreText.h>
@implementation UILabel (Extension)

+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    
    return label;
}



+ (instancetype)addLabelWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor

                             font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    
    return label;
    
}

/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,1)];
    self.attributedText = str;
    
}

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
    
}

/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

/**
 *  设置下划线
 */
- (void)setBottomLineWithColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length )];
    [str addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = str;
}

@end
