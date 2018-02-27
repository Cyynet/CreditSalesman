//
//  NewApplyViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/13.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "NewApplyViewController.h"
#import "QRCodeViewController.h"
#import "StringFilterTool.h"
#import <SVProgressHUD.h>
@interface NewApplyViewController ()<UITextFieldDelegate>

/** 产品数组 */
@property (strong, nonatomic)  NSMutableArray *productArr;

/** 产品编号 */
@property (strong, nonatomic)  NSMutableArray *productNoArr;

/** 借款期限 */
@property (strong, nonatomic)  NSMutableArray *periodArr;

/** 借款金额 */
@property (strong, nonatomic)  NSMutableArray *amountArr;

/** 记录上次点击的产品按钮 */
@property (weak, nonatomic) UIButton *lastProductBtn;

/** 记录上次点击的期数按钮 */
@property (weak, nonatomic) UIButton *lastPeriodBtn;

/** productView */
@property (strong, nonatomic)  UIView *productView;

/** periodView */
@property (strong, nonatomic)  UIView *periodView;

/** 金额框 */
@property (strong, nonatomic)  UITextField *textField;

@end

@implementation NewApplyViewController

- (NSMutableArray *)productArr {
    
    if (_productArr == nil) {
        _productArr = [NSMutableArray array];
    }
    return _productArr;
}

- (NSMutableArray *)productNoArr {
    
    if (_productNoArr == nil) {
        _productNoArr = [NSMutableArray array];
    }
    return _productNoArr;
}

- (NSMutableArray *)periodArr {
    
    if (_periodArr == nil) {
        _periodArr = [NSMutableArray array];
    }
    return _periodArr;
}

- (NSMutableArray *)amountArr {
    
    if (_amountArr == nil) {
        _amountArr = [NSMutableArray array];
    }
    return _amountArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新建申请";
    
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = ZHBackgroundColor;
    
    [self.view addSubview:self.productView];
    
    [self.view addSubview:self.periodView];
    
    //请求服务器数据
    [self requestServerData];
    
    //借款金额 和 生成二维码 按钮
    [self setupBottomView];
}

- (void)requestServerData {
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetProductInfoById.spring",kOuternet] params:nil success:^(id responseObject) {
        
        // 1. 遍历数据
        for (NSDictionary * dict in responseObject[@"data"]) {
            
            NSString *product_name = [dict objectForKey:@"product_name"];
            NSString *loan_term = [dict objectForKey:@"loan_term"];
            NSString *product_no = [dict objectForKey:@"product_no"];
            NSString *min_amount = [dict objectForKey:@"min_amount"];
            NSString *max_amount = [dict objectForKey:@"max_amount"];
            NSString *amount = [NSString stringWithFormat:@"%@-%@",min_amount,max_amount];

            //产品
            [self.productArr addObject:product_name];
            //产品编号
            [self.productNoArr addObject:product_no];
            //期数
            [self.periodArr addObject:loan_term];
            //金额
            [self.amountArr addObject:amount];
            
         }
        // 2. 显示数据
        //选择产品
        [self setupProductViews];
        //选择期限
        [self setupPeriodViewsWithIndex:0];
        
    } failure:^(NSError *error) {
        
    }];
}

- (UIView *)productView {
    
    if (!_productView) {
        
        _productView = [[UIView alloc] init];
        _productView.backgroundColor = [UIColor whiteColor];
        _productView.frame = CGRectMake(0, ZHFit(20), self.view.width, ZHFit(165));
        [self.view addSubview:_productView];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Line"]];
        lineImage.x = ZHFit(10);
        lineImage.y = ZHFit(14);
        [lineImage sizeToFit];
        [_productView addSubview:lineImage];
        
        UILabel *productLabel = [[UILabel alloc] init];
        productLabel.x = lineImage.right + 8;
        productLabel.y = lineImage.y;
        productLabel.width = 100;
        productLabel.height = lineImage.height;
        productLabel.text = @"选择产品";
        productLabel.font = fontSize(14);
        productLabel.textColor = UIColorWithRGB(0x2d2d2d);
        [_productView addSubview:productLabel];
    }
    return _periodView;
}

- (UIView *)periodView {

    if (!_periodView) {
        
        _periodView = [[UIView alloc] init];
        _periodView.backgroundColor = [UIColor whiteColor];
        _periodView.frame = CGRectMake(0, ZHFit(205), self.view.width, ZHFit(95));
        [self.view addSubview:_periodView];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Line"]];
        lineImage.x = ZHFit(10);
        lineImage.y = ZHFit(14);
        [lineImage sizeToFit];
        [self.periodView addSubview:lineImage];
        
        UILabel *productLabel = [[UILabel alloc] init];
        productLabel.x = lineImage.right + 8;
        productLabel.y = lineImage.y;
        productLabel.width = 100;
        productLabel.height = lineImage.height;
        productLabel.text = @"借款期限";
        productLabel.font = fontSize(14);
        productLabel.textColor = UIColorWithRGB(0x2d2d2d);
        [self.periodView addSubview:productLabel];
    }
    return _periodView;
}

/** 创建产品项 */
- (void)setupProductViews {
    
    for (int i = 0; i < self.productArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        NSInteger col = i % 3;
        NSInteger row = i / 3;
        NSInteger margin = ZHFit(28);
        
        btn.width = (self.view.width - 2 * ZHFit(10) - 2 * margin) / 3;
        btn.height = ZHFit(40);
        btn.x = col * (btn.width + margin) + ZHFit(10);
        btn.y = row *  (btn.height + ZHFit(20)) + ZHFit(25) + ZHFit(20);
        
        btn.tag = i;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:self.productArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWithRGB(0x888888) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWithRGB(0xffffff) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"product_box_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"product_box_select"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(clickProductBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = fontSize(14);
        [_productView addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            self.lastProductBtn = btn;
            self.textField.placeholder = [NSString stringWithFormat:@"请输入%@万借款金额",self.amountArr[0]];
        }
    }
}

/** 创建期数项 */
- (void)setupPeriodViewsWithIndex:(NSInteger )index {
    
    //1. 先移除上次创建的控件
    for (UIView *subView in self.productView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            [subView removeFromSuperview];
        }
    }
    
    //2. 创建的控件
    NSArray *countArr = [self.periodArr[index] componentsSeparatedByString:@","];
    
    for (int i = 0; i < countArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] init];
        NSInteger col = i % 4;
        NSInteger margin = ZHFit(38);
        
        btn.width = (self.view.width - 2 * ZHFit(10) - 3 * margin) / 4;
        btn.height = ZHFit(30);
        btn.x = col * (btn.width + margin) + ZHFit(10);
        btn.y = ZHFit(25) + ZHFit(20);
        
        btn.tag = i;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:[NSString stringWithFormat:@"%@期",countArr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWithRGB(0x888888) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWithRGB(0xffffff) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"number_default"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"number_select"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(clickPeriodBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = fontSize(14);
        [self.periodView addSubview:btn];
     }
}

/** 创建金额项 和 生成二维码 按钮 */
- (void)setupBottomView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, ZHFit(320), self.view.width, ZHFit(55));
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.x = ZHFit(13);
    label.y = ZHFit(20);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    label.text = @"借款金额";
    label.width = [label sizeThatFits:CGSizeMake(MAXFLOAT, ZHFit(15))].width;
    label.height = ZHFit(15);
    label.textColor = UIColorWithRGB(0x3e3e3e);
    label.font = fontSize(14);
    [view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入1-20万借款金额";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.font = fontSize(14);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.frame = CGRectMake(label.right + ZHFit(40), label.y, ZHFit(157), label.height);
    textField.textColor = UIColorWithRGB(0x676767);
    self.textField = textField;
    [view addSubview:textField];
    
    /** 汉子“万” */
    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.frame = CGRectMake(textField.right, label.y, 20, label.height);
    textlabel.text = @"万";
    textlabel.textColor = UIColorWithRGB(0x3e3e3e);
    textlabel.font = fontSize(14);
    [view addSubview:textlabel];
    
    
    //生成二维码 按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(ZHFit(38), view.bottom + ZHFit(100),self.view.width - 2 * ZHFit(38), ZHFit(44))];
    btn.backgroundColor = ZHThemeColor;
    [btn setTitle:@"生成二维码" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 0.5 * btn.height;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickQRCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

/** 点击产品 */
- (void)clickProductBtn:(UIButton *)btn {
    
    self.lastProductBtn.selected = NO;
    btn.selected = YES;
    self.lastProductBtn = btn;
    
    [self setupPeriodViewsWithIndex:btn.tag];
    
    self.textField.placeholder = [NSString stringWithFormat:@"请输入%@万借款金额",self.amountArr[btn.tag]];
}

/** 点击期数 */
- (void)clickPeriodBtn:(UIButton *)btn {
    
    self.lastPeriodBtn.selected = NO;
    btn.selected = YES;
    self.lastPeriodBtn = btn;
}

/** 生成二维码 */
- (void)clickQRCodeBtn {
    
    //1. 检查输入和选择情况
    if (self.lastPeriodBtn == NULL) {
        [SVProgressHUD showInfoWithStatus:@"      请选择借款期数     "];
        return;
    }
    if (self.textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"     请输入借款金额     "];
        return;
    }
    
    //2.判断输入金额的合法性
    NSString *min_amount = [[self.amountArr[self.lastProductBtn.tag] componentsSeparatedByString:@"-"] firstObject];
    NSString *max_amount = [[self.amountArr[self.lastProductBtn.tag] componentsSeparatedByString:@"-"] lastObject];
    
    if ([self.textField.text integerValue] < [min_amount integerValue] || [self.textField.text integerValue] > [max_amount integerValue]) {
        
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"借款金额在%@万之间",self.amountArr[self.lastProductBtn.tag]]];
        return;
    }
    
    //3.请求二维码需要的过期时间
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetDictValueByKey.spring",kOuternet] params:@{@"dic_key":@"qrcode_duration"} success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            //4. 拼接二维码字段
            NSArray *countArr = [self.periodArr[_lastProductBtn.tag] componentsSeparatedByString:@","];
            NSString *produtNo = [NSString stringWithFormat:@"%@,%@",self.productNoArr[_lastProductBtn.tag],self.productArr[_lastProductBtn.tag]];
            NSDictionary *dict = @{
                                   @"salerNo":[kUserDefaults valueForKey:@"saler_no"],
                                   @"loanMoney":[NSString stringWithFormat:@"%@0000",self.textField.text],
                                   @"productNo":produtNo,
                                   @"createTime":responseObject[@"data"][@"sys_date"],
                                   @"productTerm":countArr[_lastPeriodBtn.tag],
                                   };
            
            
            
            NSString *downloadStr = [NSString stringWithFormat:@"%@H5Pages/version_ios/ios_salesman.html?param=%@",kOuternet,[StringFilterTool dictionaryToJson:dict]];
            
            // 5.生成二维码
            QRCodeViewController *qrCodeVC = [[QRCodeViewController alloc] init];
            qrCodeVC.product_name = self.productArr[_lastProductBtn.tag];
            qrCodeVC.productTerm = countArr[_lastPeriodBtn.tag];
            qrCodeVC.loanMoney = self.textField.text;
            qrCodeVC.codeStr = downloadStr;
            qrCodeVC.dic_value = responseObject[@"data"][@"dic_value"];
            [self.navigationController pushViewController:qrCodeVC animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/** 点击键盘return键 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    if (self.textField == textField) {
        
        return [self validateNumber:string];
    }
    //否则返回yes,不限制其他textfield
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

/** 点击屏幕 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
