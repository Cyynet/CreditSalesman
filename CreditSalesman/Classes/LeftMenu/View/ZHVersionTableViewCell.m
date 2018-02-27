//
//  ZHVersionTableViewCell.m
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/25.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHVersionTableViewCell.h"
#import "UILabel+Extension.h"
#import "ZHVersionModel.h"
#import "NSString+Extension.h"
#import "UILabel+Extension.h"

@interface ZHVersionTableViewCell()

/*背景View*/
@property(nonatomic,strong)UIView * GBView;
/*版本label*/
@property(nonatomic,strong)UILabel * versionLabel;
/*日期label*/
@property(nonatomic,strong)UILabel * dateLabel;
/*更新内容label*/
@property(nonatomic,strong)UILabel * contentLabel;

@end

@implementation ZHVersionTableViewCell{

    CGFloat width;
    CGFloat edgeX;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=[UIColor clearColor];
        width = kScreenWidth - 2 * ZHFit(10);
        edgeX=ZHFit(20);
        
        self.GBView = [[UIView alloc] init];
        self.GBView.frame = CGRectMake(ZHFit(10), 20, width, ZHFit(156));
        self.GBView.backgroundColor = [UIColor whiteColor];
        self.GBView.layer.cornerRadius=ZHFit(3);
        self.GBView.layer.borderColor=UIColorWithRGB(0xd8d8d8).CGColor;
        self.GBView.layer.borderWidth=0.5;
        self.GBView.clipsToBounds=YES;
        [self.contentView addSubview:self.GBView];
        
        self.versionLabel = [[UILabel alloc] init];
        self.versionLabel.frame = CGRectMake(edgeX, 0, ZHFit(100), ZHFit(58));
        self.versionLabel.textColor = UIColorWithRGB(0x3b3b3b);
        self.versionLabel.font = fontSize(16);
        [self.GBView addSubview:self.versionLabel];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.frame = CGRectMake(self.versionLabel.right, 0, width - self.versionLabel.right - 20, ZHFit(58));
        self.dateLabel.textColor = UIColorWithRGB(0x868686);
        self.dateLabel.font = fontSize(14);
        self.dateLabel.textAlignment=NSTextAlignmentRight;
        [self.GBView addSubview:self.dateLabel];
        
        UIView *middleLine = [[UIView alloc] init];
        middleLine.frame = CGRectMake(0, ZHFit(58), width, 0.5);
        middleLine.backgroundColor=UIColorWithRGB(0xf0f0f0);
        [self.GBView addSubview:middleLine];
        
        self.contentLabel=[UILabel addLabelWithFrame:CGRectMake(edgeX, middleLine.bottom+ZHFit(20), width-ZHFit(40), ZHFit(58)) title:nil titleColor:UIColorWithRGB(0x868686) font:fontSize(14)];
        self.contentLabel.numberOfLines = 0;
        
        [self.GBView addSubview:self.contentLabel];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.frame = CGRectMake(0, 0, width, 3);
        topLine.backgroundColor=UIColorWithRGB(0xed6b00);
        [self.GBView addSubview:topLine];
    }
    
    return self;
}

+ (instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSString*)identifier{
    ZHVersionTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        
        cell=[[ZHVersionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

/*初始化cell*/
-(void)settingCellWithValue:(NSArray*)titleArray IndexPath:(NSIndexPath*)indexPath{

    if (titleArray.count>indexPath.section) {
        
        ZHVersionModel * model = [titleArray objectAtIndex:indexPath.section];
        self.versionLabel.text= [NSString stringWithFormat:@"V%@",model.ver_code];
        self.dateLabel.text = model.update_date;
        
        self.contentLabel.text = [NSString stringWithFormat:@" 更新记录\n\n%@",[model.ver_text stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]];
        CGFloat hight = [NSString computeTextSizeHeight:self.contentLabel.text Range:CGSizeMake(width-ZHFit(40), MAXFLOAT)].height;
        self.GBView.height = self.versionLabel.bottom+ZHFit(20)+hight+ZHFit(20);
        self.contentLabel.frame=CGRectMake(edgeX, self.versionLabel.bottom+ZHFit(20)+0.5, width-ZHFit(40), hight);
    }
}


@end
