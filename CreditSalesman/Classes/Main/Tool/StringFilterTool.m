//
//  StringFilterTool.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "StringFilterTool.h"

@implementation StringFilterTool

/*
 @brief 登陆密码
 */
+ (BOOL)filterByLoginPassWord:(NSString *)passWord{
    
    NSString *regex = @"^[A-Za-z0-9`~!@#$%^/?,.;:'*()_+=-]{6,16}$";
    //    NSString *regex = @"/(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,16}$/";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
}

/**
 * 手机正则匹配
 */
#define PHONENO  @"^(1[0123456789]{10})|((0[0-9]{2,3}){0,1}([2-9][0-9]{6,7}))$"
+ (BOOL)filterByPhoneNumber:(NSString *)phone {
    
    NSPredicate * telePhoneNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONENO];
    BOOL isTelephoneNumber = [telePhoneNumberPred evaluateWithObject:phone];
    return isTelephoneNumber;
}

/**
 @breif 从plist中取出版本号
 */
+ (NSString *)getCurrentVersion{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}


/**
*  字典转换为字符串
*/
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
