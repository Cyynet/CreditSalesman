//
//  UITextField+Extension.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

/**
 快速创建输入框

 @param frame frame description
 @param delegate 代理
 @return 返回输入框
 */
+ (instancetype )addFieldWithFrame:(CGRect)frame
                          delegate:(id)delegate

{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = delegate;
    textField.frame = frame;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorWithRGB(0x676767);
    
    return textField;
}

+ (instancetype )addFieldWithFrame:(CGRect)frame
                       placeholder:(NSString *)placeholder
                          delegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = fontSize(14);
    textField.delegate = delegate;
    textField.frame = frame;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textColor = UIColorWithRGB(0x3e3e3e);
    return textField;
    
}



@end
