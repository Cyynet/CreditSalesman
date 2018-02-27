//
//  NSString+Extension.h
//  01-QQ聊天布局
//
//  Created by apple on 14-4-2.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)


/**
 *  自适应高度
 *
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 返回的高度
 */
- (float) heightWithFont: (UIFont *) font withinWidth: (float) width;
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size;

/**
 @param prov 省
 @param city 市
 @param area 区
 @param town 乡镇
 @return 返回省市区的中文名
 */
+ (NSString *)appendStringWithProv:(NSString *)prov City:(NSString *)city andArea:(NSString *)area andTown:(NSString *)town;

+ (NSMutableAttributedString*)changeStringToAttributeString:(NSString*)str Range:(NSRange)range Color:(UIColor*)color;
@end
