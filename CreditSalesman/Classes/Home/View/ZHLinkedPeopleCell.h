//
//  ZHLinkedPeopleCell.h
//  CreditSalesman
//
//  Created by zhph on 2017/5/4.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHLinkedPeopleCell : UITableViewCell

/*初始化cell*/
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

/*初始化数据*/
-(void)settingCellWithValue:(NSArray*)titleArray IndexPath:(NSIndexPath*)indexPath;

@end
