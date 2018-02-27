//
//  BaseTableViewCell.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Extension.h"
#import "UITextField+Extension.h"
@interface BaseTableViewCell : UITableViewCell

/** 是否已完成 */
@property (copy, nonatomic)  NSString *alreadyLabelText;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
