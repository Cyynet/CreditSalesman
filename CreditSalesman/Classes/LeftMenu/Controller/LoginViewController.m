//
//  LoginViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "LoginViewController.h"
#import "StringFilterTool.h"
#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import "StringFilterTool.h"
#import "ActiveViewController.h"

#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#include "REFrostedViewController.h"
#import "ZHNavigationController.h"
#import "UIView+CLKeyboardOffsetView.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField * accountField;

@property(nonatomic,strong) UITextField * pwTextField;

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    // 打开键盘补偿视图
    [self.view openKeyboardOffsetView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 关闭键盘补偿视图
    [self.view closeKeyboardOffsetView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupLoginViews];
}

- (void)setupLoginViews {
    
    //LOGO
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageView.centerX = self.view.centerX;
    imageView.y = ZHFit(40);
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    
    
    //账号
    _accountField = [self addTextFiledWithLeftImage:@"手机号" viewY:imageView.bottom + ZHFit(63)];
    _accountField.placeholder = @"请输入账号";
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    //密码
    _pwTextField = [self addTextFiledWithLeftImage:@"密码" viewY:imageView.bottom + ZHFit(125)];
    _pwTextField.placeholder = @"请输入密码";
    _pwTextField.secureTextEntry = YES;
    _pwTextField.rightView = ({
        
        UIButton *secretBtn = [[UIButton alloc] init];
        [secretBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateNormal];
        [secretBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateSelected];
        [secretBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        secretBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -ZHFit(6), 0, 0);
        [secretBtn sizeToFit];
        secretBtn;
    });
    _pwTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    //账号激活
    UIButton *activeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width / 2, imageView.bottom + ZHFit(175), self.view.width / 2 - ZHFit(40), ZHFit(20))];
    [activeBtn setTitle:@"账号激活" forState:UIControlStateNormal];
    activeBtn.titleLabel.font = fontSize(14);
    activeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [activeBtn setTitleColor:UIColorWithRGB(0xed6b00) forState:UIControlStateNormal];
    [activeBtn addTarget:self action:@selector(activeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activeBtn];
    
    
    //登录
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ZHFit(40), activeBtn.bottom + ZHFit(25), kScreenWidth - ZHFit(80), ZHFit(45))];
    btn.backgroundColor = ZHThemeColor;
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 0.5 * ZHFit(45);
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

/** 账号激活 */
- (void)activeBtnClick {
    
    ActiveViewController *activeVC = [[ActiveViewController alloc] init];
    [self.navigationController pushViewController:activeVC animated:YES];
}

/** 登录 */
- (void)loginBtnClick {
    
    if (NULLString(self.accountField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return;
    }
    
    if (NULLString(self.pwTextField.text) || self.pwTextField.text.length < 6) {
        
        [SVProgressHUD showInfoWithStatus:@"密码格式错误"];
        return ;
    }
    
    NSDictionary *params = @{
                             @"username":self.accountField.text,
                             @"password":self.pwTextField.text
                            };
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@LoginBySaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            //1.提示登录成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showSuccessWithStatus:@"登录 成功"];
            });
            
            //保存用户名称
            [kUserDefaults setObject:responseObject[@"data"][@"saler_name"] forKey:@"saler_name"];
            //保存用户账号
            [kUserDefaults setObject:responseObject[@"data"][@"saler_no"] forKey:@"saler_no"];
                  
            
            //2.1创建首页和侧滑菜单 controllers
            ZHNavigationController *navigationController = [[ZHNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
            /** 访问AppDelegate全局变量 */
            AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
            appDelegate.navigationController = navigationController;
            LeftMenuViewController *menuController = [[LeftMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            
            //2.2创建 frosted view controller
            REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
            frostedViewController.direction = REFrostedViewControllerDirectionLeft;
            frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
            frostedViewController.menuViewSize = CGSizeMake(kScreenWidth * 0.73, kScreenHeight);
            frostedViewController.liveBlur = YES;
            frostedViewController.limitMenuViewSize = YES;
            
            
            //2.3成为根控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = frostedViewController;
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 显示或者隐藏密码 */
- (void)tapBtn:(UIButton *)tapBtn {
    
    tapBtn.selected = !tapBtn.isSelected;
    
    if (tapBtn.selected)  {
        _pwTextField.secureTextEntry = NO;
    }else {
        _pwTextField.secureTextEntry = YES;
    }
}

/** 检查输入内容 */
- (BOOL)checkInput {
    
    if (NULLString(self.accountField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return NO;
    }
    if (![StringFilterTool filterByPhoneNumber:self.accountField.text]) {
        
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return NO;
    }
    
    
    if (NULLString(self.pwTextField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return NO;
    }
    
    if (self.pwTextField.text.length < 6) {
        
        [SVProgressHUD showInfoWithStatus:@"密码格式错误"];
        return NO;
    }
    
    return YES;
    
}

/** 统一创建输入框 */
- (UITextField *)addTextFiledWithLeftImage:(NSString *)leftImageStr viewY:(CGFloat)viewY {
    
    UIView *cellView = [[UIView alloc] init];
    cellView.frame = CGRectMake(ZHFit(40), viewY, self.view.width - 2 * ZHFit(40), ZHFit(35));
    [self.view addSubview:cellView];
    
    //图标
    UIImageView *phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImageStr]];
    phoneImage.x = ZHFit(10);
    phoneImage.y = ZHFit(5);
    [phoneImage sizeToFit];
    [cellView addSubview:phoneImage];
    
    //输入框
    UITextField *Field = [[UITextField alloc] init];
    Field.x = phoneImage.right + ZHFit(15);
    Field.width = cellView.width - Field.x - ZHFit(15);
    Field.height = phoneImage.height;
    Field.centerY = phoneImage.centerY;
    Field.keyboardType = UIKeyboardTypeAlphabet;
    Field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    Field.delegate = self;
    [cellView addSubview:Field];
    
    //底线
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UIColorWithRGB(0xdadada);
    label.y = ZHFit(40) - 1;
    label.size = CGSizeMake(cellView.width, 1);
    [cellView addSubview:label];
    
    return Field;
    
}

/** 监听输入文本长度 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //敲删除键
    if ([string length] == 0) {
        return YES;
    }
    
    //账号
    if (textField == _accountField) {
        if (textField.text.length > 11) return NO;
    }
    //密码
    if (textField == _pwTextField) {
        if (textField.text.length > 15) return NO;
    }
    
    return YES;
}

/** 点击键盘return键 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

/** 点击屏幕 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
@end
