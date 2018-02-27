//
//  OrderTableViewCell.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "OrderTableViewCell.h"
#import <SVProgressHUD.h>
#import "UIButton+Extension.h"
#import "LoanModel.h"

@implementation OrderTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(NSUInteger)cellType {
    
    NSString *ID = @"cell";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID cellType:cellType];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = ZHBackgroundColor;
    }
    return cell;
}

- (void)setLoanModel:(List *)loanModel {
    
    _loanModel = loanModel;
    
    self.orderLabe.text = loanModel.apply_loan_key;
    self.productLabe.text = [[loanModel.loan_type componentsSeparatedByString:@","] lastObject];
    self.nameLabe.text = loanModel.cust_name;
    self.moneyLabe.text = [NSString stringWithFormat:@"申请金额：%@元",loanModel.loan_amount];
    //调节高度
    self.moneyLabe.size = [_moneyLabe sizeThatFits:CGSizeMake(MAXFLOAT, _bottomView.height)];
    self.moneyLabe.centerY = _middleView.height / 2;
    
    self.termLabe.text = [NSString stringWithFormat:@"借款期限：%@期",loanModel.loan_term];
    self.termLabe.centerY = _middleView.height / 2;
    
    self.timeLabe.text = loanModel.insert_date;
    
    //2.设置贷款状态的角标
    switch ([loanModel.audit_status integerValue]) {
        
        case 1://销售确认
            self.stateImage.image = [UIImage imageNamed:@"apply"];
            break;
        case 2://审核中
            self.stateImage.image = [UIImage imageNamed:@"checking"];
            break;
        case 3://已放弃
            self.stateImage.image = [UIImage imageNamed:@"give_up"];
            break;
        case 4://已取消
            self.stateImage.image = [UIImage imageNamed:@"cancel"];
            break;
        case 5://已拒绝 业务端直接拒绝
        case 11://已拒绝 信审不通过
            self.stateImage.image = [UIImage imageNamed:@"refuse"];
            break;
        case 6://资料补充(驳回)
            self.stateImage.image = [UIImage imageNamed:@"reject"];
            break;
        case 7://审核通过
            self.stateImage.image = [UIImage imageNamed:@"pass"];
            break;
        case 8://面签
            self.stateImage.image = [UIImage imageNamed:@"ign_contract"];
            break;
        case 9://提现中
            self.stateImage.image = [UIImage imageNamed:@"crediting"];
            break;
        case 10://已放款
            self.stateImage.image = [UIImage imageNamed:@"creditpay"];
            break;
        case 12://放款失败
            self.stateImage.image = [UIImage imageNamed:@"defeated"];
            break;
        default:
            break;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(NSUInteger)cellType {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(10, 20, kScreenWidth - 20, ZHFit(136));
        bgView.layer.cornerRadius = ZHFit(5);
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        
        //上部白色栏
        [bgView addSubview:self.topView];
        //右上角角标
        [self.topView addSubview:self.stateImage];
        //订单号
        [self.topView addSubview:self.orderLabe];
        //方案类型
        [self.topView addSubview:self.productLabe];
        //电话
        [self.topView addSubview:self.phoneBtn];
        //姓名
        [self.topView addSubview:self.nameLabe];
        
        //中部灰色栏
        [bgView addSubview:self.middleView];
        //申请金额
        [self.middleView addSubview:self.moneyLabe];
        //期数
        [self.middleView addSubview:self.termLabe];
        
        if (cellType == UITableViewCellTypeCustomPatch) {
       
            bgView.frame = CGRectMake(10, 20, kScreenWidth - 20, ZHFit(193));
            //下部灰色栏
            [bgView addSubview:self.bottomView];
            //时间
            [self.bottomView addSubview:self.timeLabe];
            //资料补充
            [self.bottomView addSubview:self.addInfoBtn];
        }
    }
    return self;
}

// 上部灰色栏
- (UIView *)topView {
    
    if (!_topView) {
        
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth - 20, ZHFit(96));
        _topView.backgroundColor = UIColorWithRGB(0xffffff);
        _topView.userInteractionEnabled = YES;
        
        //为订单视图添加长按手势
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [_topView addGestureRecognizer:longPressGr];
        
    }
    return _topView;
}

// 上部图标
- (UIImageView *)stateImage {
    
    if (!_stateImage) {
        
        _stateImage = [[UIImageView alloc] init];
        _stateImage.y = 0;
        _stateImage.x = _topView.right - ZHFit(57);
        _stateImage.width = ZHFit(57);
        _stateImage.height = _stateImage.width;
    }
    return _stateImage;
}

//方案类型
- (UILabel *)productLabe {
    
    if (!_productLabe) {
        
        _productLabe = [[UILabel alloc] init];
        _productLabe.frame = CGRectMake(ZHFit(20), _orderLabe.bottom + ZHFit(20), 130, ZHFit(13));
        _productLabe.font = fontBoldSize(16);
        _productLabe.textColor = UIColorWithRGB(0x333333);
    }
    return _productLabe;
}

//订单号
- (UILabel *)orderLabe {
    
    if (!_orderLabe) {
        
        _orderLabe = [[UILabel alloc] init];
        _orderLabe.frame = CGRectMake(ZHFit(20), ZHFit(22), _topView.width, ZHFit(20));
        _orderLabe.font = fontBoldSize(14);
        _orderLabe.textColor = UIColorWithRGB(0x333333);
    }
    return _orderLabe;
}

//电话
- (UIButton *)phoneBtn {
    
    if (!_phoneBtn) {
        
        _phoneBtn = [[UIButton alloc] init];
        [_phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [_phoneBtn sizeToFit];
        _phoneBtn.centerY = _productLabe.centerY;
        _phoneBtn.right = _topView.right - 20;
        _phoneBtn.custom_acceptEventInterval = 3.0f;
        [_phoneBtn addTarget:self action:@selector(clickPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

//姓名
- (UILabel *)nameLabe {
    
    if (!_nameLabe) {
        
        _nameLabe = [[UILabel alloc] init];
        _nameLabe.x = 200;
        _nameLabe.y = _orderLabe.bottom + ZHFit(20);
        _nameLabe.width = _phoneBtn.x - 200 - 10;
        _nameLabe.height = _productLabe.height;
        _nameLabe.font = fontBoldSize(14);;
        _nameLabe.textAlignment = NSTextAlignmentRight;
        _nameLabe.textColor = UIColorWithRGB(0x333333);
    }
    return _nameLabe;
}

//中部灰色栏
- (UIView *)middleView {
    
    if (!_middleView) {
        
        _middleView = [[UIView alloc] init];
        _middleView.frame = CGRectMake(0, _topView.bottom, _topView.width, ZHFit(40));
        _middleView.backgroundColor = UIColorWithRGB(0xf7f7f7);
    }
    return _middleView;
}

//申请金额
- (UILabel *)moneyLabe {
    
    if (!_moneyLabe) {
        
        UIImageView *leftImaeg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money"]];
        leftImaeg.x = ZHFit(20);
        leftImaeg.centerY = ZHFit(20);
        [_middleView addSubview:leftImaeg];
        
        _moneyLabe = [[UILabel alloc] init];
        _moneyLabe.x = leftImaeg.right + 10;
        _moneyLabe.y = 0;
        _moneyLabe.height = _middleView.height;
        _moneyLabe.font = fontSize(14);
        _moneyLabe.textColor = UIColorWithRGB(0x676767);
        
        if (kScreenWidth < 375) {
            leftImaeg.x = ZHFit(15);
            _moneyLabe.x = leftImaeg.right + 4;
        }
    }
    return _moneyLabe;
}

//期数
- (UILabel *)termLabe {
    
    if (!_termLabe) {
        
        _termLabe = [[UILabel alloc] init];
        _termLabe.text = [NSString stringWithFormat:@"借款期限：6期"];
        [_termLabe sizeToFit];
        _termLabe.x = _middleView.right - ZHFit(20) - _termLabe.size.width;
        _termLabe.centerY = _moneyLabe.centerY;
        _termLabe.font = fontSize(14);
        _termLabe.textColor = UIColorWithRGB(0x676767);
        _termLabe.textAlignment = NSTextAlignmentRight;
        
        UIImageView *rightImaeg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number"]];
        rightImaeg.x = _middleView.width - ZHFit(105) - ZHFit(30) - rightImaeg.width;
        rightImaeg.centerY = ZHFit(20);
        [_middleView addSubview:rightImaeg];

    }
    return _termLabe;
}

//下部白色栏
- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, _middleView.bottom, _topView.width, ZHFit(58));
        _bottomView.backgroundColor = UIColorWithRGB(0xffffff);
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}

//时间
- (UILabel *)timeLabe {
    
    if (!_timeLabe) {
        
        _timeLabe = [[UILabel alloc] init];
        _timeLabe.frame = CGRectMake(ZHFit(20), 0, _bottomView.width / 3 * 2, _bottomView.height);
        _timeLabe.font = fontSize(14);
        _timeLabe.textColor = UIColorWithRGB(0x9f9f9f);
    }
    return _timeLabe;
}

//资料补充
- (UIButton *)addInfoBtn {
    
    if (!_addInfoBtn) {
        
        _addInfoBtn = [[UIButton alloc] init];
        [_addInfoBtn setTitle:@"资料补充" forState:UIControlStateNormal];
        [_addInfoBtn setTitleColor:ZHThemeColor forState:UIControlStateNormal];
        _addInfoBtn.height = ZHFit(30);
        _addInfoBtn.width = ZHFit(80);
        _addInfoBtn.centerY = ZHFit(29);
        _addInfoBtn.right = _bottomView.right - 10;
        _addInfoBtn.titleLabel.font = fontSize(14);
        _addInfoBtn.layer.borderColor = ZHThemeColor.CGColor;
        _addInfoBtn.layer.borderWidth = 1;
        _addInfoBtn.layer.cornerRadius = _addInfoBtn.height / 2;
        _addInfoBtn.layer.masksToBounds = YES;
        [_addInfoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addInfoBtn;
}

/**
 * 客户放弃/拒绝/补充资料
 */
- (void)clickBtn:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(clickCustomBtnWithLoanKey:Btn:)]) {
        
        [self.delegate clickCustomBtnWithLoanKey:self.loanModel.apply_loan_key Btn:btn];
    }
}

/**
 * 点击电话按钮
 */
- (void)clickPhoneBtn {
    
    if (NULLString(self.loanModel.mobile)) {
        
        [SVProgressHUD showInfoWithStatus:@"电话号码不正确"];
    }else{
        
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.loanModel.mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self addSubview:callWebview];
    }
}

/**
 *  处理长按手势
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    // 1.弹框提示
    [SVProgressHUD showSuccessWithStatus:@"订单号已复制 !"];
    
    // 2. 长按的时候保存进件号
    [[UIPasteboard generalPasteboard] setString:self.orderLabe.text];
    
}

@end
