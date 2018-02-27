//
//  ZHTextView.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/17.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHTextView : UITextView

@property (copy, nonatomic) NSString *placeHoledr;

@property (strong, nonatomic) UILabel *placeLabel;

@property (strong, nonatomic) UIColor *placeHoledrColor;

@end
