//
//  SearchBar.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/27.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 背景
        self.background = [UIImage imageNamed:@"box"];
        
        // 设置字体
        self.font = fontSize(14);
        
        // 添加放大镜 initWithImage:默认UIImageView的尺寸跟图片一样
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serch"]];
        self.leftView = leftView;
        leftView.contentMode = UIViewContentModeCenter;
        
        //  注意：一定要设置，想要显示搜索框左边的视图，一定要设置左边视图的模式
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 显示清除按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.placeholder = @"输入单号、姓名可查询历史订单";
        
        self.returnKeyType = UIReturnKeySearch;
    }
    return self;
}

+ (instancetype)searchBar {
    
    return [[self alloc]init];
}
//控制placeHolder的位置，左右缩20
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x += 1;
    return placeholderRect;
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}

//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x += 10;
    return editingRect;
}

//控制左视图位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15;
    return iconRect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // iOS6文字不会垂直居中
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}


@end
