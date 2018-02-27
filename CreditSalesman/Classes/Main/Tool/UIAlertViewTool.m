//
//  UIAlertViewTool.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "UIAlertViewTool.h"

@interface UIAlertViewTool()

@property(copy,nonatomic)void (^cancelClicked)();

@property(copy,nonatomic)void (^confirmClicked)();

@end

@implementation UIAlertViewTool

+ (void)showAlertView:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle otherTitle:(NSString *)otherButtonTitle cancelBlock:(void (^)())cancle confrimBlock:(void (^)())confirm {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        
        UIAlertAction *cancelAction;
        if (cancelButtonTitle) {
            
            cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                cancle();
                
            }];
            
            [alertController addAction:cancelAction];
        }
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            confirm();
        }];
        
        // Add the actions.
        
        [alertController addAction:otherAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ==== 单个或多个按钮 ======
+ (void)showAlertViewWith:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message CallBackBlock:(CallBackBlock)block destructiveButtonTitle:(NSString *)destructiveBtnTitle otherButtonTitles:(NSString *)otherBtnTitles,... {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (otherBtnTitles.length) {
        
        UIAlertAction *otherActions = [UIAlertAction actionWithTitle:otherBtnTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            (!destructiveBtnTitle.length) ? block(0) : ((destructiveBtnTitle.length) ? block(1) : block(2));
        }];
        [alertController addAction:otherActions];
        
        va_list args;
        va_start(args, otherBtnTitles);
        if (otherBtnTitles.length) {
            NSString * otherString;
            int index = 2;
            (!destructiveBtnTitle.length) ? (index = 0) : ((destructiveBtnTitle.length) ? (index = 1) : (index = 2));
            while ((otherString = va_arg(args, NSString*))) {
                index ++ ;
                UIAlertAction * otherActions = [UIAlertAction actionWithTitle:otherString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    block(index);
                }];
                [alertController addAction:otherActions];
            }
        }
        va_end(args);
    }
    
    if (destructiveBtnTitle.length) {
        UIAlertAction * destructiveAction = [UIAlertAction actionWithTitle:destructiveBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        [alertController addAction:destructiveAction];
    }
    
    
    [viewController presentViewController:alertController animated:YES completion:nil];
    
    //如果没有按钮，自动延迟消失
    if (!destructiveBtnTitle.length && !otherBtnTitles) {
        //此时self指本类
        [self performSelector:@selector(dismissAlertController:) withObject:alertController afterDelay:1.0f];
    }
}

#pragma mark ==== 点击事件 ======
+ (void)dismissAlertController:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:YES completion:nil];
}



@end
