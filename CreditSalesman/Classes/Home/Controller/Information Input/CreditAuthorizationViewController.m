//
//  CreditAuthorizationViewController.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/25.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "CreditAuthorizationViewController.h"
#import "UIButton+Extension.h"
#import "ImageCell.h"
#import "TitleAndTextFieldCell.h"
#import "AuthorizationLoginBottomCell.h"
#import "AuthorizationBottomCell.h"
#import "CreditSuccessCell.h"
#import "SessionTool.h"
#import <SVProgressHUD.h>
@interface CreditAuthorizationViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSInteger _currentState;                            //当前步骤  0:登陆 1:获取报告 2:完成
    NSArray *_titleArr;                                 //表格标题数组
    NSArray *_placeholderArr;                           //提示语数组
    NSString *_loginName;                               //登录名
    NSString *_password;                                //密码
    NSString *_userRandomCode;                          //用户输入的随机验证码
    NSString *_isflag;                                  //服务器返回500标志
    NSString *_messageCode;                             //人行验证码
    NSString *_idCardNo;                                //身份证号码
    NSInteger _requestTime;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *commitButton;      //登录按钮
@property(nonatomic,strong)UIButton *getCreditButton;   //获取报告按钮
@property(nonatomic,strong)UIButton *returnButton;      //返回按钮
@property(nonatomic,strong)UIImageView *vercodeImage;   //随机验证码图片
- (void)InitializeDataSource;
- (void)InitializeInterface;

@end

@implementation CreditAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"征信授权";
    [self InitializeDataSource];
    [self InitializeInterface];
}

#pragma mark - Initialize
- (void)InitializeDataSource {
    _requestTime = 1;
    _currentState = 0;
    _isflag = @"1";
    _titleArr = @[@"登录名",@"密码",@"验证码"];
    _placeholderArr = @[@"请输入登录名",@"请输入密码",@"请输入验证码"];
    _idCardNo = [SessionTool GetInstance].infoDic[@"idcard_no"];
    [self respondsToChangeVercode];
}

- (void)InitializeInterface {
    self.view.backgroundColor = UIColorWithRGB(0xf5f8fa);
    [self.view addSubview:self.tableView];
}

#pragma mark - Responds
/**
 登录按钮
 */
- (void)respondsToCommit {
    if (NULLString(_loginName) || NULLString(_password) || NULLString(_userRandomCode)) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    [self login];
}


/**
 获取信贷报告
 */
- (void)respondsToGetCredit {
    if (NULLString(_loginName) || NULLString(_messageCode)) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    [self getCredit];
}


/**
 成功返回
 */
- (void)respondsToReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? _currentState == 0 ? 3 : _currentState == 1 ? 2 : 1 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if (!cell) {
            cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        }
        cell.image.image = [UIImage imageNamed:_currentState == 0 ? @"征信登录" : _currentState == 1 ? @"征信获取" : @"征信完成"];
        cell.image.contentMode = UIViewContentModeScaleAspectFit;
        cell.image.frame = CGRectMake(ZHFit(30), ZHFit(12), kScreenWidth-ZHFit(60), ZHFit(76));
        return cell;
    } else if (indexPath.section == 1) {
        
        //获取征信报告成功
        if (_currentState == 2) {
            CreditSuccessCell *cell = [[CreditSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CreditSuccessCell"];
            return cell;
        } else if (_currentState == 0){
            //登录界面
            TitleAndTextFieldCell *cell = [[TitleAndTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleAndTextFieldCell"];
            cell.title.text = _titleArr[indexPath.row];
            cell.detail.placeholder = _placeholderArr[indexPath.row];
            if (indexPath.row == 0) {
                cell.detail.text = _loginName;
            }
            if (indexPath.row == 1) {
                [cell.detail setSecureTextEntry:YES];
            }
            if (indexPath.row == 2) {
                cell.line.frame = CGRectMake(0, ZHFit(54), kScreenWidth, ZHFit(1));
                [cell.contentView addSubview:self.vercodeImage];
            }
            cell.textValueChangedBlock = ^(NSString *valueStr){
                if (indexPath.row == 0) {
                    _loginName = valueStr;
                } else if (indexPath.row == 1) {
                    _password = valueStr;
                } else {
                    _userRandomCode = valueStr;
                }
            };
            return cell;
        } else {
            //获取征信报告界面
            TitleAndTextFieldCell *cell = [[TitleAndTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleAndTextFieldCell1"];
            if (indexPath.row == 0) {
                cell.title.text = @"用户名";
                cell.detail.text = _loginName;
            } else {
                cell.title.text = @"人行验证码";
                cell.detail.placeholder = @"请输入人行验证码";
                cell.line.frame = CGRectMake(0, ZHFit(54), kScreenWidth, ZHFit(1));
            }
            cell.textValueChangedBlock = ^(NSString *valueStr){
                if (indexPath.row == 0) {
                    _loginName = valueStr;
                } else {
                    _messageCode = valueStr;
                }
            };
            return cell;
        }
    } else if (indexPath.section == 2) {
        //底部按钮
        UITableViewCell *button = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
        if (!button) {
            button = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buttonCell"];
        }
        button.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [button.contentView addSubview:_currentState == 0 ? self.commitButton : _currentState == 1 ? self.getCreditButton : self.returnButton];
        button.selectionStyle = UITableViewCellSelectionStyleNone;
        return button;
    } else {
        //底部提示语
        AuthorizationBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthorizationBottomCell"];
        AuthorizationLoginBottomCell *loginBottomCell = [tableView dequeueReusableCellWithIdentifier:@"AuthorizationLoginBottomCell"];
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        loginBottomCell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        if (_currentState == 1) {
            return cell;
        } else if (_currentState == 0) {
            return loginBottomCell;
        } else {
            loginBottomCell.hidden = YES;
            return loginBottomCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ZHFit(100);
    } else if (indexPath.section == 1) {
        return _currentState != 2 ? ZHFit(55) : ZHFit(280);
    } else if (indexPath.section == 2) {
        return ZHFit(50);
    } else {
        return ZHFit(170);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return ZHFit(20);
    } else if (section == 2){
        return ZHFit(50);
    } else {
        return ZHFit(20);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Netwoking
/**
 生成验证码
 */
- (void)respondsToChangeVercode {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{
                            @"idCard":[SessionTool GetInstance].infoDic[@"idcard_no"],
                            @"isflag":_isflag};
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetVerifyCode.spring",kOuternet] params:param success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:responseObject[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            weakSelf.vercodeImage.image = [UIImage imageWithData:imageData];
        } else if ([responseObject[@"code"] isEqualToString:@"500"]) {
            _isflag = @"2";
            _requestTime++;
            if (_requestTime > 2) {
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            } else {
                [weakSelf respondsToChangeVercode];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
/**
 登录
 */
- (void)login {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"loginName":_loginName,
                            @"password":_password,
                            @"picCode":_userRandomCode,
                            @"idCard":[SessionTool GetInstance].infoDic[@"idcard_no"],
                            @"isflag":_isflag
                            };    //征信授权
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@CreditAuth.spring",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            _currentState = 1;
            [weakSelf.tableView reloadData];
        } else if ([responseObject[@"code"] isEqualToString:@"500"]) {
            [SVProgressHUD showInfoWithStatus:@"请重新输入验证码"];
            _isflag = @"2";
            TitleAndTextFieldCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
            cell.detail.text = @"";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf respondsToChangeVercode];
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
}
//获取征信报告
- (void)getCredit {
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"loginName":_loginName,
                            @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"],
                            @"messageCode":_messageCode,
                            @"idCard":[SessionTool GetInstance].infoDic[@"idcard_no"],
                            @"isflag":_isflag};
    
    //征信报告生成
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@CreditInfo.spring",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            _currentState = 2;
            [weakSelf.tableView reloadData];
        } else if ([responseObject[@"code"] isEqualToString:@"500"]) {
            [SVProgressHUD showInfoWithStatus:@"报告获取失败,请重试"];
            _currentState = 0;
            _isflag = @"2";
            [weakSelf.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf respondsToChangeVercode];
            });
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getter and Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorWithRGB(0xf5f8fa);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"AuthorizationBottomCell" bundle:nil] forCellReuseIdentifier:@"AuthorizationBottomCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"AuthorizationLoginBottomCell" bundle:nil] forCellReuseIdentifier:@"AuthorizationLoginBottomCell"];
    }
    return _tableView;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton addCustomButtonWithFrame:CGRectMake(ZHFit(40), 0, kScreenWidth-ZHFit(80), ZHFit(50)) title:@"登录" backgroundColor:UIColorWithRGB(0xed6b00) titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
            [self respondsToCommit];
        }];
        _commitButton.titleLabel.font = fontSize(26);
    }
    return _commitButton;
}

- (UIButton *)getCreditButton {
    if (!_getCreditButton) {
        _getCreditButton = [UIButton addCustomButtonWithFrame:CGRectMake(ZHFit(40), 0, kScreenWidth-ZHFit(80), ZHFit(50)) title:@"获取报告" backgroundColor:UIColorWithRGB(0xed6b00) titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
            [self respondsToGetCredit];
        }];
        _getCreditButton.titleLabel.font = fontSize(16);
    }
    return _getCreditButton;
}

- (UIButton *)returnButton {
    if (!_returnButton) {
        _returnButton = [UIButton addCustomButtonWithFrame:CGRectMake(ZHFit(40), 0, kScreenWidth-ZHFit(80), ZHFit(50)) title:@"返回" backgroundColor:UIColorWithRGB(0xed6b00) titleColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
            [self respondsToReturn];
        }];
        _returnButton.titleLabel.font = fontSize(16);
    }
    return _returnButton;
}

- (UIImageView *)vercodeImage {
    if (!_vercodeImage) {
        _vercodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - ZHFit(90), ZHFit(12), ZHFit(80), ZHFit(31))];
        _vercodeImage.image = [UIImage imageNamed:@"刷新验证码"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToChangeVercode)];
        [_vercodeImage addGestureRecognizer:tap];
        _vercodeImage.userInteractionEnabled = YES;
    }
    return _vercodeImage;
}

@end
