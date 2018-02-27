
#import "ActiveViewController.h"
#import "UIAlertViewTool.h"
#import <SVProgressHUD.h>
#import "UIView+CLKeyboardOffsetView.h"

@interface ActiveViewController ()<UITextFieldDelegate>

/** 账号 */
@property(nonatomic,strong) UITextField * accountField;

/** 手机号 */
@property(nonatomic,strong) UITextField * phoneField;

/** 验证码*/
@property(weak,nonatomic) UITextField *phoneCodeField;

/** 倒计时数字 */
@property (nonatomic, assign) NSInteger number;

//用户密码
@property(weak,nonatomic) UITextField *pwTextField;

/** 倒计时按钮 */
@property (strong, nonatomic) UIButton *timerBtn;

/** 年龄 */
@property (copy, nonatomic)  NSString *wallege;

@end

@implementation ActiveViewController

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
    self.title = @"账号激活";
    self.view.backgroundColor = [UIColor whiteColor];
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //创建子控件
    [self setupLoginViews];
}

- (void)setupLoginViews{
    
    //LOGO
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageView.centerX = self.view.centerX;
    imageView.y = ZHFit(40);
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    
    CGFloat kMargin = ZHFit(55);
    CGFloat accountTop = imageView.bottom + ZHFit(65);
    
    
    //账号
    _accountField = [self addTextFiledWithLeftImage:@"phone_number" viewY:accountTop];
    _accountField.placeholder = @"请输入业务员编号";
    _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    //业务员手机号
    _phoneField = [self addTextFiledWithLeftImage:@"手机号" viewY:accountTop + kMargin];
    _phoneField.placeholder = @"业务员手机号";
    _phoneField.userInteractionEnabled = NO;
    
    
    //验证码
    _phoneCodeField = [self addTextFiledWithLeftImage:@"verification_code" viewY:accountTop + kMargin * 2];
    _phoneCodeField.placeholder = @"请输入验证码";
    _phoneCodeField.keyboardType = UIKeyboardTypeNumberPad;
      
    
    //密码
    _pwTextField = [self addTextFiledWithLeftImage:@"密码" viewY:accountTop + kMargin * 3];
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
    
    //账号登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width / 2, accountTop + ZHFit(215), self.view.width / 2 - ZHFit(40), ZHFit(20))];
    [loginBtn setTitle:@"账号登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = fontSize(14);
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [loginBtn setTitleColor:UIColorWithRGB(0xed6b00) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    
    //激活账号
    UIButton *activeBtn = [[UIButton alloc] initWithFrame:CGRectMake(ZHFit(40), loginBtn.bottom + ZHFit(25), kScreenWidth - ZHFit(80), ZHFit(45))];
    activeBtn.backgroundColor = ZHThemeColor;
    [activeBtn setTitle:@"激活账号" forState:UIControlStateNormal];
    activeBtn.layer.cornerRadius = 0.5 * ZHFit(45);
    activeBtn.layer.masksToBounds = YES;
    [activeBtn addTarget:self action:@selector(activeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:activeBtn];
}

/** 账号登录 */
- (void)loginClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/** 账号激活 */
- (void)activeBtnClick {
    
    if ([self checkInput]) {
        
        NSDictionary *params = @{
                                 @"username":self.accountField.text,
                                 @"password":self.pwTextField.text,
                                 @"phoneNum":self.phoneField.text,
                                 @"phoneCode":self.phoneCodeField.text
                                 };
        
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@ActivateSaler.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                });
                //返回去登录
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

/** 检查输入是否正确*/
- (BOOL)checkInput{
    
    if (NULLString(self.accountField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return NO;
    }

    if (NULLString(self.phoneCodeField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return NO;
    }
    
    if (self.phoneCodeField.text.length < 4) {
        [SVProgressHUD showInfoWithStatus:@"验证码位数不够"];
        return NO;
    }
    
    
    if (NULLString(self.pwTextField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"密码格式错误"];
        return NO;
    }
    
    return YES;
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

/** 统一创建输入框 */
- (UITextField *)addTextFiledWithLeftImage:(NSString *)leftImageStr viewY:(CGFloat)viewY {
    
    UIView *cellView = [[UIView alloc] init];
    cellView.frame = CGRectMake(ZHFit(40), viewY, self.view.width - 2 * ZHFit(40), ZHFit(35));
    [self.view addSubview:cellView];
    
    //图标
    UIImageView *phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftImageStr]];
    phoneImage.centerX = ZHFit(18);
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
    
    //如果左侧图片是验证码的图，就创建个按钮
    if ([leftImageStr isEqualToString:@"verification_code"]) {
        
        Field.width = cellView.width - ZHFit(105) - Field.x;
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorWithRGB(0xdadada);
        label.x = Field.right;
        label.size = CGSizeMake(1, phoneImage.height);
        label.centerY = phoneImage.centerY;
        [cellView addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(label.right, Field.y, ZHFit(105), phoneImage.height)];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWithRGB(0xed6b00) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.titleLabel.font = fontSize(16);
        [btn addTarget:self action:@selector(getPhoneCode) forControlEvents:UIControlEventTouchUpInside];
        self.timerBtn = btn;
        [cellView addSubview:btn];
    }

    //底线
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UIColorWithRGB(0xdadada);
    label.y = ZHFit(40) - 1;
    label.size = CGSizeMake(cellView.width, 1);
    [cellView addSubview:label];
    
    return Field;
}

#pragma mark - / ************获取验证码 ****************/
- (void)getPhoneCode {
    
    if (NULLString(self.accountField.text)) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入账号"];
        return;
    }
    
    //2.获取验证码
    NSString* str = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"我们将会发送验证码到手机", nil),self.phoneField.text];
    
    [UIAlertViewTool showAlertView:self title:@"确认手机号码" message:str cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        //1.请求
        NSDictionary *params = @{
                                 @"phoneNo" : self.phoneField.text,
                                 @"type" : @"ActivateSaler"
                                };
        
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetPhoneCode.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                //2.添加倒计时
                self.number = 60;
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
                [timer fire];
                
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            }
         } failure:^(NSError *error) {
            
        }];
    }];
    
    
}

//计算定时器时间
-(void)updateTime:(NSTimer *)Timer {
    
    self.number --;
    self.timerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.timerBtn.titleLabel.text = [NSString stringWithFormat:@"%lds 后重发",(long)self.number];
    
    self.timerBtn.userInteractionEnabled = NO;
    
    if (self.number == 0){
        
        [Timer invalidate];
        
        self.timerBtn.titleLabel.text = @"获取验证码";
        self.timerBtn.userInteractionEnabled = YES;
    }
}

#pragma mark -  textField delegate
/** 输入完业务员账号调用 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.accountField && textField.text.length > 2) {
        
        NSDictionary *params = @{
                                 @"salerNo":self.accountField.text
                                };
        
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@FindSalerBySalerNo.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                _phoneField.text = responseObject[@"data"][@"saler_mobile"];
            }else{
                _phoneField.userInteractionEnabled = YES;
            }
        } failure:^(NSError *error) {
            
            _phoneField.userInteractionEnabled = YES;
        }];
    }
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
