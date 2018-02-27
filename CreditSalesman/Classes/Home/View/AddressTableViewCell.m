//
//  AddressTableViewCell.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%ld,%ld",(long)[indexPath section],(long)[indexPath row]];
    AddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 默认控件的属性设置
        self.textLabel.font = fontSize(14);
        self.textLabel.textColor = UIColorWithRGB(0x3e3e3e);
        self.detailTextLabel.font = fontSize(14);
        self.detailTextLabel.numberOfLines = 0;
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.textLabel.y = ZHFit(20);
    self.detailTextLabel.y = CGRectGetMaxY(self.textLabel.frame) + ZHFit(20);

}


@end
