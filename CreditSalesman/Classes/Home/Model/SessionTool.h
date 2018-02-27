//
//  SessionTool.h
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionTool : NSObject

//请求的字典
@property (strong,nonatomic) NSDictionary * infoDic;

//实现单例方法
+ (SessionTool *) GetInstance;

@end
