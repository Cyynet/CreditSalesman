//
//  TitleMenuView.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "TitleMenuView.h"

@interface TitleMenuView ()

/** 上次选中的按钮 */
@property (strong, nonatomic)  UIButton *lastBtn;

@end

@implementation TitleMenuView

- (id)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = ZHBackgroundColor;
        
        for (int i = 0; i < titleArr.count; i ++) {
            
            [self addButton:titleArr[i] andIndex:i];
        }
    }
    return self;
}

-(void)addButton:(NSString *)title andIndex:(NSInteger)index{
    
    UIButton *btn = [[UIButton alloc] init];
    btn.tag = index;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = fontSize(14);
    
    if (index == 0) {
        [btn setBackgroundImage:[UIImage imageNamed:@"left_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"left_select"] forState:UIControlStateSelected];
        btn.selected = YES;
        self.lastBtn = btn;
    }
    if (index == 1) {
        [btn setBackgroundImage:[UIImage imageNamed:@"center_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"center_selectt"] forState:UIControlStateSelected];
    }
    if (index == 2) {
        [btn setBackgroundImage:[UIImage imageNamed:@"right_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"right_select"] forState:UIControlStateSelected];
    }
    
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorWithRGB(0xffffff) forState:UIControlStateSelected];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)titleButtonClick:(UIButton *)btn {
    
    self.lastBtn.selected = NO;
    btn.selected = YES;
    self.lastBtn = btn;
    
    if (self.titleBlock) {
        self.titleBlock(btn.tag);
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = ZHFit(78);
    CGFloat btnH = ZHFit(28);
    
    for(int i = 0;i < self.subviews.count; i++){
        
        btnX = self.width / 2 + (i - 1.5) * btnW;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

@end
