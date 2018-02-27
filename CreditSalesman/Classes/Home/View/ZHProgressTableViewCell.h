//
//  ZHProgressTableViewCell.h
//  CreditSalesman
//
//  Created by zhph on 2017/4/27.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHProgressTableViewCell : UITableViewCell

/*创建cell*/
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSIndexPath *)indexPath;

/*初始化cell*/
- (void)setDataSource:(NSArray*)titleArray isFirst:(BOOL)isFirst isLast:(BOOL)isLast IndexPath:(NSIndexPath*)indexPath;

@end
