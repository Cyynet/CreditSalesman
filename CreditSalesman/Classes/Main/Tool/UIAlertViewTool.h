//
//  UIAlertViewTool.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

/** alertView的回调block */

typedef void (^CallBackBlock)(NSInteger btnIndex);

@interface UIAlertViewTool : NSObject

/**自定义UIAlertView*/
+ (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherButtonTitle cancelBlock:(void (^)())cancle confrimBlock:(void (^)())confirm;


/**
 有两个或者多个按钮 确定 

 @param viewController    控制器
 @param title             提示的标题
 @param message           提示信息
 @param textBlock         回调
 @param destructiveBtnTitle destructiveBtn按钮
 @param otherBtnTitles 确定按钮
 */
+ (void)showAlertViewWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message
            CallBackBlock:(CallBackBlock)textBlock  destructiveButtonTitle:(NSString *)destructiveBtnTitle
        otherButtonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

@end
