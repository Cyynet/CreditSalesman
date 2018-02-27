//
//  ZHUpgradeView.h
//  CreditSalesman
//
//  Created by zhph on 2017/5/5.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHUpgradeView : UIView

/*升级内容*/
@property(nonatomic,copy)NSString * versionString;

/*创建一个View*/
+(instancetype)shareAddUpgradeView;
/*显示*/
-(void)showInKwindow;
/*隐退*/
-(void)hiddenInView;

/*升级 block*/
@property(nonatomic,copy)void(^ UpdateAppBlock)(void);

/** 是否强制升级 */
@property (copy, nonatomic)  NSString *is_coerce_update;

@end
