//
//  AdditionInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/15.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "AdditionInfoViewController.h"
#import "BaseTableViewCell.h"
#import "UILabel+Extension.h"
#import "UIView+CLKeyboardOffsetView.h"
#import "ZHTextView.h"
#import "SessionTool.h"
#import "UIAlertViewTool.h"
#import <SVProgressHUD.h>
#import "HelpViewController.h"
#import "CreditAuthorizationViewController.h"
#import "NSString+Extension.h"

@interface AdditionInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,LQPhotoPickerViewDelegate>

/** 标题数组 */
@property (strong, nonatomic) NSMutableArray *titles;

/** tableView */
@property (strong, nonatomic) UITableView *tableView;

/** 工资流水卡号 */
@property (strong, nonatomic)  UITextField *textField;

/** 备注信息 */
@property (strong, nonatomic) ZHTextView *textView;

/** 信贷经理上传(text) */
@property(nonatomic,strong) UILabel *uploadLabel;

/** 文字说明视图 */
@property (strong, nonatomic)  UIView *explainView;

/** 上传图片文字说明 */
@property(nonatomic,strong) UILabel *explainLabel;

/** 提交审核按钮 */
@property(nonatomic,strong) UIButton *submitBtn;

@end

@implementation AdditionInfoViewController

- (NSMutableArray *)titles {
    
    if (_titles == nil) {
        _titles = [NSMutableArray arrayWithObjects:@"个人信用授权",@"运营商认证",@"芝麻分授权",nil];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数据
    [self initData];
    
    //创建tableView
    [self setupTableView];
    
    //创建提示标语
    [self setupTableHeadView];
    
    //创建tableView FootView
    [self setupTableFootView];
}

- (void)initData {
    
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = ZHBackgroundColor;
    tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - 50 - 64);
    tableView.dataSource = self;
    tableView.delegate  = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 组头位置
- (void)setupTableHeadView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorWithRGB(0xededed);
    view.frame =  CGRectMake(0, 0, self.view.width, 134);
   
    
    NSString *audit_result = [SessionTool GetInstance].infoDic[@"audit_result"];
    NSString *audit_status = [SessionTool GetInstance].infoDic[@"audit_status"];

    
    UILabel *messageLabel  = [[UILabel alloc] init];
    
    if (!NULLString(audit_result) && ([audit_status integerValue] == 6)) {
        
        messageLabel.frame = CGRectMake(0, 0, self.view.width, 35);
        messageLabel.font = fontSize(13);
        messageLabel.textColor = UIColorWithRGB(0x8988989);
        messageLabel.numberOfLines = 0;
        messageLabel.backgroundColor = UIColorWithRGB(0xfff2c8);
        messageLabel.text = [NSString stringWithFormat:@"    驳回原因：%@",audit_result];
        
        messageLabel.height = [messageLabel.text heightWithFont:fontSize(13) withinWidth:self.view.width -20];
    
        [view addSubview:messageLabel];
        
        view.height = 134 + messageLabel.height;
    }
    
    //时间
    UILabel *timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, messageLabel.bottom, self.view.width, 54)];
    timeLabel.font = fontSize(14);
    timeLabel.textColor = UIColorWithRGB(0x8988989);
    timeLabel.backgroundColor = ZHBackgroundColor;
    timeLabel.text = [NSString stringWithFormat:@"    申请时间：%@",[SessionTool GetInstance].infoDic[@"insert_date"]];
    [view addSubview:timeLabel];
    
    //messageLabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, timeLabel.bottom, view.width - 20, 80)];
    label.text = [NSString stringWithFormat:@"所需材料：%@",[SessionTool GetInstance].infoDic[@"require_memo"]];
    label.textColor = UIColorWithRGB(0x292929);
    label.numberOfLines = 0;
    label.font = fontSize(14);
    [label setRowSpace:5.0f];
    [view addSubview:label];
    
    self.tableView.tableHeaderView = view;
}

#pragma mark - 组尾位置
- (void)setupTableFootView {
    
    UIView *footView = [[UIView alloc] init];
    footView.frame = CGRectMake(0, 0, self.view.width, ZHFit(600));
    self.tableView.tableFooterView = footView;
    
    //工资流水卡号
    UILabel *floatLabel = [[UILabel alloc] init];
    floatLabel.frame = CGRectMake(10, 0, self.view.width, ZHFit(54));
    floatLabel.text = @"工资流水卡号";
    floatLabel.textColor = UIColorWithRGB(0x898989);
    floatLabel.font = [UIFont boldSystemFontOfSize:14];
    [footView addSubview:floatLabel];
    
    //文本框背景
    UIView *floatView = [[UIView alloc] init];
    floatView.frame = CGRectMake(0, floatLabel.bottom, self.view.width, floatLabel.height);
    floatView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:floatView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入工资流水卡号";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.frame = CGRectMake(8, 0, self.view.width - 16, floatView.height);
    textField.textColor = UIColorWithRGB(0x676767);
    self.textField = textField;
    self.textField.text=[SessionTool GetInstance].infoDic[@"bank_water_cardno"];
    [floatView addSubview:textField];
    
    //借款备注
    UILabel *signTextLabel = [[UILabel alloc] init];
    signTextLabel.frame = CGRectMake(10, floatView.bottom, self.view.width, floatLabel.height);
    signTextLabel.text = @"借款备注";
    signTextLabel.textColor = UIColorWithRGB(0x898989);
    signTextLabel.font = [UIFont boldSystemFontOfSize:14];
    [footView addSubview:signTextLabel];
    
    //文本框背景
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, signTextLabel.bottom, self.view.width, ZHFit(110));
    bgView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:bgView];
    //备注文本信息
    ZHTextView *textView = [[ZHTextView alloc] init];
    textView.frame = CGRectMake(5, 0, bgView.width - 10, bgView.height);
    textView.placeHoledr = @"补充说明（选填）";
    textView.delegate = self;
    textView.text = [SessionTool GetInstance].infoDic[@"loan_memo"];
    textView.placeLabel.hidden=textView.text.length!=0? YES:NO;
    self.textView = textView;
    [bgView addSubview:textView];
    
    
    //信贷经理上传区
    UILabel *uploadLabel = [[UILabel alloc] init];
    uploadLabel.frame = CGRectMake(10, bgView.bottom, self.view.width, ZHFit(54));
    uploadLabel.text = @"信贷经理上传区";
    uploadLabel.textColor = UIColorWithRGB(0x898989);
    uploadLabel.font = [UIFont boldSystemFontOfSize:14];
    self.uploadLabel = uploadLabel;
    [footView addSubview:uploadLabel];
    
    /**
     *  photoPicker   依次设置
     */
    self.LQPhotoPicker_superView = footView;
    
    self.LQPhotoPicker_imgMaxCount = 30;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    UIView *explainView = [[UIView alloc] init];
    self.explainView = explainView;
    explainView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:explainView];
    
    
    //上传图片文字说明
    UILabel *explainLabel = [[UILabel alloc]init];
    explainLabel.text = @"点击图片可查看大图";
    explainLabel.textColor = UIColorWithRGB(0xc1c1c1);
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.font = [UIFont boldSystemFontOfSize:12];
    self.explainLabel = explainLabel;
    [explainView addSubview:explainLabel];
    
    //提交审核
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.backgroundColor = ZHThemeColor;
    [submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 0.5 * ZHFit(42);
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
    [footView addSubview:submitBtn];
    
    //更新位置
    [self updateViewsFrame];
}

#pragma mark - 更新视图位置
- (void)updateViewsFrame {
    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:CGRectGetMaxY(self.uploadLabel.frame)];
    
    //说明文字
    _explainView.frame = CGRectMake(0, self.uploadLabel.bottom + [self LQPhotoPicker_getPickerViewFrame].size.height, self.view.width, 50);
    _explainLabel.frame = CGRectMake(0, 20, self.view.width, 10);
    
    //提交按钮
    _submitBtn.frame = CGRectMake(ZHFit(40), _explainView.bottom + 30, self.view.width - ZHFit(80), ZHFit(42));
    
    //tableFooterView的高
    CGFloat tableFooterViewHeight = CGRectGetMaxY(_submitBtn.frame) + 30;
    self.tableView.tableFooterView.height = tableFooterViewHeight;
    self.tableView.contentSize = CGSizeMake(0,tableFooterViewHeight + ZHFit(54) * 3 + self.tableView.tableHeaderView.height);
}

- (void)LQPhotoPicker_pickerViewFrameChanged {
    
    [self updateViewsFrame];
}

#pragma mark - 点击提交审核
- (void)submitBtnClick {
    
    if (self.LQPhotoPicker_smallDataImageArray.count == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请先上传照片"];
        return;
    }
    
    if ([self.photosDesArr containsObject:@"工资流水"] && NULLString(self.textField.text)) {
        [SVProgressHUD showInfoWithStatus:@"请输入工资流水卡号"];
        return;
    }
    
    [UIAlertViewTool showAlertView:self title:@"提示" message:@"确定提交该贷款申请吗？" cancelTitle:@"取消" otherTitle:@"确定" cancelBlock:^{
        
    } confrimBlock:^{
        
        NSDictionary *params = @{
                                 @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"],
                                 @"bank_water_cardno":self.textField.text,
                                 @"loan_memo":self.textView.text
                                 };
        
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@CommitLoanInfoOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                //提示提交成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD showSuccessWithStatus:@"提交 成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            NSLog(@"%@",responseObject);
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
}

#pragma mark - Table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.titles[indexPath.row]];
    cell.textLabel.text = self.titles[indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.alreadyLabelText = [SessionTool GetInstance].infoDic[@"credit_auth_state"];
    }else if (indexPath.row == 1) {
        cell.alreadyLabelText = [SessionTool GetInstance].infoDic[@"operator_state"];
    }else{
        cell.alreadyLabelText = [SessionTool GetInstance].infoDic[@"zhima_state"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        CreditAuthorizationViewController *creditAuthorizationVC = [[CreditAuthorizationViewController alloc] init];
        creditAuthorizationVC.infoCompleteBlock = ^(BOOL isComplete){
            if (isComplete) {
                if (isComplete) {
                    ((BaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).alreadyLabelText = @"1";
                }
            }
        };
        [self.navigationController pushViewController:creditAuthorizationVC animated:YES];
    }else if (indexPath.row == 1) {
        
        NSDictionary *param = @{
                                @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"]
                               };
        
        //跳转到运营商授权界面
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GenerateReports.spring",kOuternet] params:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                HelpViewController *webVC = [[HelpViewController alloc]init];
                webVC.urlString = responseObject[@"data"][@"redirectUrl"];
                webVC.authBlock = ^(BOOL isAuth) {
                    if (isAuth) {
                        
                        ((BaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).alreadyLabelText = @"1";
                    }
                };
                [self.navigationController pushViewController:webVC animated:YES];
            }
        } failure:^(NSError *error) {
        }];
    }else{
        
        //跳转到芝麻分授权界面

        NSDictionary *param = @{
                                @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"]
                               };
        
        //跳转到运营商授权界面
        [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetZhiMaScore.spring",kOuternet] params:param success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                HelpViewController *webVC = [[HelpViewController alloc]init];
                webVC.urlString = responseObject[@"data"][@"redirectUrl"];
                webVC.zhiMaBlock = ^(BOOL isAuth) {
                    [self getZhimaScoreWithIndexPath:indexPath];
                };
                [self.navigationController pushViewController:webVC animated:YES];
            }else if ([responseObject[@"code"] isEqualToString:@"100"]) {
                
               ((BaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).alreadyLabelText = @"1";
            }

        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark - 第二次调用芝麻分
- (void)getZhimaScoreWithIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *param = @{
                            @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"]
                            };
    
    //跳转到运营商授权界面
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@GetZhiMaScore.spring",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"100"]) {
            
            ((BaseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath]).alreadyLabelText = @"已完成";
        };
    } failure:^(NSError *error) {
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ZHFit(54);
}

#pragma mark - 让键盘退出
- (void)viewTapped {
    
    [self.view endEditing:YES];
}

#pragma mark - textView delegate
-(void)textViewDidChange:(UITextView *)textView {
    // textview 改变字体的行间距
    // 判断是否有候选字符，如果不为nil，代表有候选字符
    if(textView.markedTextRange == nil){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 3; // 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    // 打开键盘补偿视图
    [self.view openKeyboardOffsetView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 关闭键盘补偿视图
    [self.view closeKeyboardOffsetView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
