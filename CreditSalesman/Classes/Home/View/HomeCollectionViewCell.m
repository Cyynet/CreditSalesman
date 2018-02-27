//
//  HomeCollectionViewCell.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/30.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)setSelected:(BOOL)selected{

    [super setSelected: selected];
    
    if (selected) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.textColor = UIColorWithRGB(0x5d5d5d);
        desLabel.font = [UIFont systemFontOfSize:16];
        self.desLabe = desLabel;
        [self.contentView addSubview:desLabel];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 *  在这里可以布局contentView里面的控件
 *
 *  @param layoutAttributes 直接继承于NSObject 形式上类似于CALayer
 */
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    self.iconView.width = layoutAttributes.frame.size.width - ZHFit(58 * 2);
    self.iconView.height = self.iconView.width;
    self.iconView.y = ZHFit(20);
    self.iconView.centerX = layoutAttributes.frame.size.width / 2;
    
    
    self.desLabe.width = layoutAttributes.frame.size.width;
    self.desLabe.height = 20;
    self.desLabe.bottom = layoutAttributes.frame.size.height - ZHFit(20);

}



@end
