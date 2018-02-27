//
//  ChangPwViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ChangPwViewController.h"
#import "BaseTableViewCell.h"
#import "UITextField+Extension.h"
#import "StringFilterTool.h"
#import <SVProgressHUD.h>
#import "ZHNavigationController.h"
#import "LoginViewController.h"

#define textFieldFrame CGRectMake(ZHFit(90), 0, self.view.width - ZHFit(105), ZHFit(54))

@interface ChangPwViewController ()<UITextFieldDelegate>

/** 旧密码 */
@property (strong, nonatomic) UITextField *oldField;

/** 新密码 */
@property (strong, nonatomic) UITextField *lastField;

@end

@implementation ChangPwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    self.view.backgroundColor = ZHBackgroundColor;
    self.titles = [NSMutableArray arrayWithObjects:@"旧密码",@" 新密码", nil];
    
    [self setupFooter];
}


//设置tableView的组尾
- (void)setupFooter {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ZHFit(200))];
    self.tableView.tableFooterView = view;
    
    UIButton *changBtn = [[UIButton alloc] initWithFrame:CGRectMake(ZHFit(38), ZHFit(120),self.view.width - 2 * ZHFit(38), ZHFit(44))];
    changBtn.backgroundColor = ZHThemeColor;
    [changBtn setTitle:@"修改" forState:UIControlStateNormal];
    changBtn.layer.cornerRadius = 0.5 * ZHFit(45);
    changBtn.layer.masksToBounds = YES;
    [changBtn addTarget:self action:@selector(changBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:changBtn];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    
    if (indexPath.row == 0) {
        
        _oldField = [UITextField addFieldWithFrame:textFieldFrame placeholder:@"请输入旧密码" delegate:self];
        _oldField.secureTextEntry = YES;
        _oldField.rightView = ({
            
            UIButton *secretBtn = [[UIButton alloc] init];
            [secretBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateNormal];
            [secretBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateSelected];
            [secretBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
            [secretBtn sizeToFit];
            secretBtn.tag = indexPath.row;
            secretBtn;
        });
        _oldField.rightViewMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_oldField];
    }
    if (indexPath.row == 1) {
        
        _lastField = [UITextField addFieldWithFrame:textFieldFrame placeholder:@"请输入6-16位新密码" delegate:self];
        _lastField.secureTextEntry = YES;
        _lastField.rightView = ({
            
            UIButton *secretBtn = [[UIButton alloc] init];
            [secretBtn setImage:[UIImage imageNamed:@"闭眼"] forState:UIControlStateNormal];
            [secretBtn setImage:[UIImage imageNamed:@"睁眼"] forState:UIControlStateSelected];
            [secretBtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
            [secretBtn sizeToFit];
            secretBtn.tag = indexPath.row;
            secretBtn;
        });
        _lastField.rightViewMode = UITextFieldViewModeAlways;

        [cell.contentView addSubview:_lastField];
        
    }
    return cell;
}

- (void)changBtnClick {
    
    if ([self checkInput]) {
        
        NSDictionary *params = @{
                                 @"salerNo":[kUserDefaults objectForKey:@"saler_no"],
                                 @"oldPassword":self.oldField.text,
                                 @"newPassword":self.lastField.text
                                 };
        
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@UpdateSalerPassword.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                //1.提示登录成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"修改成功，请重新登录"];
                });
                
                //移除存储的数据
                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                [kUserDefaults removePersistentDomainForName:appDomain];
                //重新设置根控制器
                ZHNavigationController *nav = [[ZHNavigationController alloc] initWithRootViewController:[LoginViewController alloc]];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = nav;
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}

/** 显示或者隐藏密码 */
- (void)tapBtn:(UIButton *)tapBtn {
    
    if (tapBtn.tag == 0) {
        
        tapBtn.selected = !tapBtn.isSelected;
        
        if (tapBtn.selected)  {
            _oldField.secureTextEntry = NO;
        }else {
            _oldField.secureTextEntry = YES;
        }
    }else{
        tapBtn.selected = !tapBtn.isSelected;
        
        if (tapBtn.selected)  {
            _lastField.secureTextEntry = NO;
        }else {
            _lastField.secureTextEntry = YES;
        }
    }
}

/** 检查输入内容 */
- (BOOL)checkInput{
    
    if (NULLString(self.oldField.text)) {
        [SVProgressHUD showInfoWithStatus:@"请输入旧密码"];
        return NO;
    }
    
    if (NULLString(self.lastField.text)) {
        [SVProgressHUD showInfoWithStatus:@"请输入新密码"];
        return NO;
    }
    
    
    if (![StringFilterTool filterByLoginPassWord:self.lastField.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入6-16位字母或数字"];
        return NO;
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //敲删除键
    if ([string length] == 0) {
        return YES;
    }
    
    //账号
    if (textField == _oldField) {
        if (textField.text.length > 15) return NO;
    }
    if (textField == _lastField) {
        if (textField.text.length > 15) return NO;
    }
    return YES;
}

/** 点击键盘return键 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
