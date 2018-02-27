//
//  OrderTableViewCell.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;

typedef NS_ENUM(NSUInteger, UITableViewCellType) {
    
    /** 默认单元格cell  */
    UITableViewCellTypeDefault,
    /** 客户补件的cell 底部没有时间和补件按钮 */
    UITableViewCellTypeCustomPatch,
};

@protocol  OrderTableViewCellDelegate<NSObject>

//点击cell上面按钮的代理
- (void)clickCustomBtnWithLoanKey:(NSString *)loanKey Btn:(UIButton *)btn;

@end

@interface OrderTableViewCell : UITableViewCell

@property (assign,nonatomic) UITableViewCellType  cellType;

/** topView */
@property (strong, nonatomic)  UIView *topView;

/** middleView */
@property (strong, nonatomic)  UIView *middleView;

/** bottomView */
@property (strong, nonatomic)  UIView *bottomView;

/** 产品类型 */
@property(strong,nonatomic)   UILabel *productLabe;

/** 订单号 */
@property(strong,nonatomic)   UILabel *orderLabe;

/** 姓名 */
@property(strong,nonatomic)   UILabel *nameLabe;

/** 金额 */
@property(strong,nonatomic)   UILabel *moneyLabe;

/** 期数 */
@property(strong,nonatomic)   UILabel *termLabe;

/** 电话按钮 */
@property (strong, nonatomic)  UIButton *phoneBtn;

/** 审核状态图标 */
@property (strong, nonatomic)  UIImageView *stateImage;

/** 时间 */
@property(strong,nonatomic)   UILabel *timeLabe;

/** 资料补充 */
@property (strong, nonatomic)  UIButton *addInfoBtn;

/** 模型 */
@property (strong, nonatomic)  List *loanModel;

@property (nonatomic, weak) id<OrderTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(NSUInteger)cellType;

@end
