//
//  NSString+Extension.m
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (float) heightWithFont: (UIFont *) font withinWidth: (float) width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    return ceil(textRect.size.height + 20);
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark 计算文字的高度
+ (CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size{
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontSize(14)} context:nil].size;
}

/**
 @return 返回省市区的中文名
 */
+ (NSString *)appendStringWithProv:(NSString *)prov City:(NSString *)city andArea:(NSString *)area andTown:(NSString *)town {
    
    NSString *str1 = [[prov componentsSeparatedByString:@","] lastObject];
    NSString *str2 = [[city componentsSeparatedByString:@","] lastObject];
    NSString *str3 = [[area componentsSeparatedByString:@","] lastObject];
    
    return [NSString stringWithFormat:@"%@ %@ %@ %@",str1,str2,str3,town];
}

#pragma mark 设置NSMutableAttributedString
+ (NSMutableAttributedString*)changeStringToAttributeString:(NSString*)str Range:(NSRange)range Color:(UIColor*)color{
    
    NSMutableAttributedString * attributeStr =[[NSMutableAttributedString alloc]initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributeStr;
}
@end
