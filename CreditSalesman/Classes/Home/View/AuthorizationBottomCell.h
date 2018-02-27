//
//  AuthorizationBottomCell.h
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/25.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secendLabelRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secendLabelLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdTop;

@end
