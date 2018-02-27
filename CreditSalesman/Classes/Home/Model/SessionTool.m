//
//  SessionTool.m
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "SessionTool.h"

// 单例对象
static SessionTool *instance;

@implementation SessionTool

// 单例
+ (SessionTool *) GetInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
            
        }
    }
    return instance;
}

-(id) init
{
    if (self = [super init]) {
        self.infoDic = [NSDictionary dictionary];
    }
    return self;
}


@end
