//
//  HelpViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController

@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,copy) void(^authBlock)(BOOL);
@property(nonatomic,copy) void(^zhiMaBlock)(BOOL);


@end
