//
//  BaseTableViewCell.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

/**  */
@property (strong, nonatomic)  UILabel *alreadyLabel;


@end

@implementation BaseTableViewCell

#pragma mark - 初始化
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString *ID = [NSString stringWithFormat:@"%ld,%ld",(long)[indexPath section],(long)[indexPath row]];
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //cell 默认控件的属性设置
        self.textLabel.font = fontSize(14);
        self.textLabel.textColor = UIColorWithRGB(0x3e3e3e);
        self.detailTextLabel.font = fontSize(14);
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *alreadyLabel = [[UILabel alloc] init];
        alreadyLabel.frame = CGRectMake(kScreenWidth - ZHFit(55), 0, ZHFit(55), self.height);
        alreadyLabel.centerY = ZHFit(27);
        alreadyLabel.font = fontSize(14);
        self.alreadyLabel = alreadyLabel;
        [self.contentView addSubview:alreadyLabel];
    }
    return self;
}

- (void)setAlreadyLabelText:(NSString *)alreadyLabelText {

    _alreadyLabel.text = alreadyLabelText;
    
    if ([alreadyLabelText isEqualToString:@"1"]) {
        
        _alreadyLabel.text = @"已完成";
        self.alreadyLabel.textColor = UIColorWithRGB(0x000000);
    }else{
        _alreadyLabel.text = @"未完成";
        self.alreadyLabel.textColor = UIColorWithRGB(0x9e9e9e);
    }
}

//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
////    CGContextFillRect(context, rect);
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, UIColorWithRGB(0xdadada).CGColor);
//    CGContextStrokeRect(context,CGRectMake(0, rect.size.height, rect.size.width,0.1));
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //调整子标题的颜色
    self.detailTextLabel.textColor = UIColorWithRGB(0x000000);
    self.detailTextLabel.x = ZHFit(150);
    self.detailTextLabel.width = kScreenWidth - ZHFit(155);
}


@end
