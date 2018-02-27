//
//  CustomPatchTableViewCell.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/19.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "CustomPatchCell.h"
#import "UILabel+Extension.h"
#import "UIButton+Extension.h"
#import "LoanModel.h"
#import <SVProgressHUD.h>

@interface CustomPatchCell ()

/** topView */
@property (strong, nonatomic)  UIView *topView;

/** bottomView */
@property (strong, nonatomic)  UIView *bottomView;

/** 订单号 */
@property(strong,nonatomic)   UILabel *orderLabe;

/** 时间 */
@property(strong,nonatomic)   UILabel *timeLabe;

/** 产品类型 */
@property(strong,nonatomic)   UILabel *productLabe;

/** 姓名 */
@property(strong,nonatomic)   UILabel *nameLabe;

/** 金额 */
@property(strong,nonatomic)   UILabel *moneyLabe;

/** 期数 */
@property(strong,nonatomic)   UILabel *termLabe;

/** 电话按钮 */
@property (strong, nonatomic)  UIButton *phoneBtn;

/** 客户放弃 */
@property (strong, nonatomic)  UIButton *giveUpBtn;

/** 拒绝 */
@property (strong, nonatomic)  UIButton *refuseBtn;

/** 资料补充 */
@property (strong, nonatomic)  UIButton *addInfoBtn;

@end


@implementation CustomPatchCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *ID = [NSString stringWithFormat:@"%ld,%ld",(long)[indexPath section],(long)[indexPath row]];
    CustomPatchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[CustomPatchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = ZHBackgroundColor;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(10, 20, kScreenWidth - 20, ZHFit(216));
        bgView.backgroundColor = UIColorWithRGB(0xeaeaea);
        bgView.layer.cornerRadius = ZHFit(8);
        bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:bgView];
        
        // 上部灰色栏
        [bgView addSubview:self.topView];
        //订单号
        [self.topView addSubview:self.orderLabe];
        //时间
        [self.topView addSubview:self.timeLabe];
        
        
        //下部白色栏
        [bgView addSubview:self.bottomView];
        //方案类型
        [self.bottomView addSubview:self.productLabe];
        //电话
        [self.bottomView addSubview:self.phoneBtn];
        //姓名
        [self.bottomView addSubview:self.nameLabe];
        //申请金额
        [self.bottomView addSubview:self.moneyLabe];
        //期数
        [self.bottomView addSubview:self.termLabe];
        //客户放弃
        [self.bottomView addSubview:self.giveUpBtn];
        //拒绝
        [self.bottomView addSubview:self.refuseBtn];
        //资料补充
        [self.bottomView addSubview:self.addInfoBtn];
        
    }
    return self;
}

- (void)setLoanModel:(List *)loanModel {
    
    _loanModel = loanModel;

    self.orderLabe.text = loanModel.apply_loan_key;
    self.timeLabe.text = loanModel.insert_date;
    self.productLabe.text = loanModel.loan_type;
    self.nameLabe.text = loanModel.cust_name;
    self.moneyLabe.text = [NSString stringWithFormat:@"申请金额：%@万元",loanModel.loan_amount];
    //调节高度
    self.moneyLabe.size = [_moneyLabe sizeThatFits:CGSizeMake(_productLabe.height, MAXFLOAT)];
    
    self.termLabe.text = [NSString stringWithFormat:@"%@期",loanModel.loan_term];
}


// 上部灰色栏
- (UIView *)topView {
    
    if (!_topView) {
        
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth - 20, ZHFit(60));
        _topView.backgroundColor = UIColorWithRGB(0xeaeaea);
        _topView.userInteractionEnabled = YES;
        
        //为订单视图添加长按手势
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [_topView addGestureRecognizer:longPressGr];

    }
    return _topView;
}

//订单号
- (UILabel *)orderLabe {
    
    if (!_orderLabe) {
        
        _orderLabe = [[UILabel alloc] init];
        _orderLabe.frame = CGRectMake(10, 0, _topView.width, ZHFit(60));
        _orderLabe.font = fontSize(14);
        _orderLabe.textColor = UIColorWithRGB(0x5d5d5d);
    }
    return _orderLabe;
}

//时间
- (UILabel *)timeLabe {
    
    if (!_timeLabe) {
        
        _timeLabe = [[UILabel alloc] init];
        _timeLabe.frame = CGRectMake(_topView.width / 2, 0, _topView.width / 2  - 10, _orderLabe.height);
        _timeLabe.font = fontSize(14);
        _timeLabe.textAlignment = NSTextAlignmentRight;
        _timeLabe.textColor = UIColorWithRGB(0x9f9f9f);
    }
    return _timeLabe;
}

//下部白色栏
- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, _topView.bottom, _topView.width, ZHFit(156));
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ZHFit(98), self.bottomView.width, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xdadada);
        [self.bottomView addSubview:lineView];
    }
    return _bottomView;
}

//方案类型
- (UILabel *)productLabe {
    
    if (!_productLabe) {
        
        _productLabe = [[UILabel alloc] init];
        _productLabe.frame = CGRectMake(10, ZHFit(20), 90, ZHFit(15));
         _productLabe.font = fontBoldSize(16);
        _productLabe.textColor = UIColorWithRGB(0x383838);
    }
    return _productLabe;
}

//电话
- (UIButton *)phoneBtn {
    
    if (!_phoneBtn) {
        
        _phoneBtn = [[UIButton alloc] init];
        [_phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [_phoneBtn sizeToFit];
        _phoneBtn.centerY = _productLabe.centerY;
        _phoneBtn.right = _bottomView.right - 10;
        _phoneBtn.custom_acceptEventInterval = 3.0f;
        [_phoneBtn addTarget:self action:@selector(clickPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

//姓名
- (UILabel *)nameLabe {
    
    if (!_nameLabe) {
        
        _nameLabe = [[UILabel alloc] init];
        _nameLabe.frame = CGRectMake(_productLabe.right, _productLabe.y, _phoneBtn.x - _productLabe.right - 10, _productLabe.height);
        _nameLabe.font = fontSize(14);
        _nameLabe.textAlignment = NSTextAlignmentRight;
        _nameLabe.textColor = UIColorWithRGB(0x383838);
    }
    return _nameLabe;
}

//申请金额
- (UILabel *)moneyLabe {
    
    if (!_moneyLabe) {
        
        _moneyLabe = [[UILabel alloc] init];
        _moneyLabe.frame = CGRectMake(10, _productLabe.bottom + ZHFit(26), 135, _productLabe.height);
        _moneyLabe.font = fontSize(14);
        _moneyLabe.textColor = UIColorWithRGB(0x676767);
    }
    return _moneyLabe;
}

//期数
- (UILabel *)termLabe {
    
    if (!_termLabe) {
        
        _termLabe = [[UILabel alloc] init];
        _termLabe.size = CGSizeMake(ZHFit(45), ZHFit(20));
        _termLabe.x = _moneyLabe.right + 10;
        _termLabe.centerY = _moneyLabe.centerY;
        _termLabe.font = fontSize(14);
        _termLabe.backgroundColor = UIColorWithRGB(0x8d8d8d);
        _termLabe.textAlignment = NSTextAlignmentCenter;
        _termLabe.layer.cornerRadius = ZHFit(3);
        _termLabe.layer.masksToBounds = YES;
        _termLabe.textColor = [UIColor whiteColor];
    }
    return _termLabe;
}

//客户放弃
- (UIButton *)giveUpBtn {
    
    if (!_giveUpBtn) {
        
        _giveUpBtn = [[UIButton alloc] init];
        _giveUpBtn.titleLabel.font = fontBoldSize(14);
        [_giveUpBtn setTitleColor:UIColorWithRGB(0x747474) forState:UIControlStateNormal];
        [_giveUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_giveUpBtn setTitle:@"客户放弃" forState:UIControlStateNormal];
        [_giveUpBtn.titleLabel setBottomLineWithColor:UIColorWithRGB(0x747474)];
//        _giveUpBtn.tag = UIButtonStyleGiveUp;
        _giveUpBtn.size = [_giveUpBtn.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT,ZHFit(58))];
        _giveUpBtn.height = ZHFit(58);
        _giveUpBtn.x = 11;
        _giveUpBtn.centerY = ZHFit(98) + ZHFit(29);
        [_giveUpBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giveUpBtn;
}

//拒绝
- (UIButton *)refuseBtn {
    
    if (!_refuseBtn) {
        
        _refuseBtn = [[UIButton alloc] init];
        _refuseBtn.frame = CGRectMake(_giveUpBtn.right + 20, ZHFit(98), ZHFit(35), ZHFit(58));
        _refuseBtn.titleLabel.font = fontBoldSize(14);
        [_refuseBtn setTitleColor:UIColorWithRGB(0x747474) forState:UIControlStateNormal];
        [_refuseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        [_refuseBtn.titleLabel setBottomLineWithColor:UIColorWithRGB(0x747474)];
        _refuseBtn.size = [_refuseBtn.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT,ZHFit(58))];
        _refuseBtn.height = ZHFit(58);
        _refuseBtn.x = _giveUpBtn.right + 28;
        _refuseBtn.centerY = ZHFit(98) + ZHFit(29);
//        _refuseBtn.tag = UIButtonStyleRefuse;
        [_refuseBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refuseBtn;
}

//资料补充
- (UIButton *)addInfoBtn {
    
    if (!_addInfoBtn) {
        
        _addInfoBtn = [[UIButton alloc] init];
        [_addInfoBtn setImage:[UIImage imageNamed:@"data_supplement"] forState:UIControlStateNormal];
        [_addInfoBtn sizeToFit];
        _addInfoBtn.centerY = _refuseBtn.centerY;
        _addInfoBtn.right = _bottomView.right - 10;
        _addInfoBtn.tag = UIButtonStyleAddInfo;
        [_addInfoBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addInfoBtn;
}

/**
 * 客户放弃/拒绝/补充资料
 */
- (void)clickBtn:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(clickCustomBtnWithType:andLoanKey:)]) {
        
        [self.delegate clickCustomBtnWithType:btn.tag andLoanKey:self.loanModel.apply_loan_key];
    }
}

/**
 * 点击电话按钮
 */
- (void)clickPhoneBtn {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-56847412"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
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
