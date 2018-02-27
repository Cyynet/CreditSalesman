//
//  AuthorizationBottomCell.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/25.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "AuthorizationBottomCell.h"

@implementation AuthorizationBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _firstLabelLeft.constant = ZHFit(35);
    _secendLabelLeft.constant = ZHFit(35);
    _secendLabelRight.constant = ZHFit(35);
    _thirdLeft.constant = ZHFit(35);
    _fourthLeft.constant = ZHFit(35);
    _fourthRight.constant = ZHFit(35);
    _thirdTop.constant = ZHFit(20);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
