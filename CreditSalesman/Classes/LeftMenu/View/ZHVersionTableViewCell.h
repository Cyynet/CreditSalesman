//
//  ZHVersionTableViewCell.h
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/25.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHVersionTableViewCell : UITableViewCell

/*创建cell*/
+(instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier;

/*初始化cell*/
-(void)settingCellWithValue:(NSArray*)titleArray IndexPath:(NSIndexPath*)indexPath;

@end
