//
//  StringFilterTool.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFilterTool : NSObject

/**
 @brief 登陆密码
 */
+ (BOOL)filterByLoginPassWord:(NSString *)passWord;

/**
 * 手机正则匹配
 */
+ (BOOL)filterByPhoneNumber:(NSString *)phone;

/**
 @breif 从plist中取出版本号
 */
+ (NSString *)getCurrentVersion;

/**
 *  字典转换为字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
