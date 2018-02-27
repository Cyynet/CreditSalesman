//
//  CustomPatchTableViewCell.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/19.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;
typedef NS_ENUM(NSUInteger, UIButtonStyle) {
 
    /** 客户放弃按钮 */
//    UIButtonStyleGiveUp  = 3,
    /** 拒绝按钮 */
//    UIButtonStyleRefuse  = 5,
    /** 补充信息按钮 */
    UIButtonStyleAddInfo = 4,
};

@protocol  CustomPatchCellDelegate<NSObject>

//点击cell上面按钮的代理

- (void)clickCustomBtnWithType:(UIButtonStyle )buttonType andLoanKey:(NSString *)loanKey;

@end

@interface CustomPatchCell : UITableViewCell

@property (assign,nonatomic) UIButtonStyle  buttonType;

@property (nonatomic, weak) id<CustomPatchCellDelegate> delegate;

/** 模型 */
@property (strong, nonatomic)  List *loanModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
