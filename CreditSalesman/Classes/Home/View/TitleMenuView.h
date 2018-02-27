//
//  TitleMenuView.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TitleBlock)(NSInteger index);

@interface TitleMenuView : UIView

@property (nonatomic,copy) TitleBlock titleBlock;

/**
*  根据传入的标题数组初始化
*/
- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@end
