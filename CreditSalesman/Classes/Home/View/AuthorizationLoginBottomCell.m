//
//  AuthorizationLoginBottomCell.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/5/10.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "AuthorizationLoginBottomCell.h"

@implementation AuthorizationLoginBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _firstLabelLeft.constant = ZHFit(35);
    _secenLabelLeft.constant = ZHFit(35);
    _secendLabelRight.constant = ZHFit(35);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
