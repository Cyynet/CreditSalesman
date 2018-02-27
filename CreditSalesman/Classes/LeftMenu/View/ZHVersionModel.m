//
//  ZHVersionModel.m
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/25.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHVersionModel.h"

@implementation ZHVersionModel


/* 设置模型属性名和字典key之间的映射关系 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"ID" : @"id",
             };
}

@end
