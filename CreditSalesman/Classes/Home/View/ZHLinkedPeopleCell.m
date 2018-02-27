//
//  ZHLinkedPeopleCell.m
//  CreditSalesman
//
//  Created by zhph on 2017/5/4.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHLinkedPeopleCell.h"

@interface ZHLinkedPeopleCell()
/*背景视图*/
@property(nonatomic,strong)UIView *BGView;
/*名字或者身份证*/
@property(nonatomic,strong)UILabel * nameLabel;
/*关系*/
@property(nonatomic,strong)UILabel * contectLabel;
/*电话*/
@property(nonatomic,strong)UILabel * phoneLabel;
/*知悉与否*/
@property(nonatomic,strong)UILabel * knowLabel;
/*身份证*/
@property(nonatomic,strong)UILabel * cardLabel;
/*身份证号码*/
@property(nonatomic,strong)UILabel * cardNumLabel;

@end

@implementation ZHLinkedPeopleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=ZHBackgroundColor;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ZHFit(54))];
        self.BGView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.BGView];
        
        self.BGView.clipsToBounds=YES;
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(12),0, ZHFit(92), ZHFit(54))];
        self.nameLabel.textAlignment=NSTextAlignmentLeft;
        self.nameLabel.font=fontSize(14);
        self.nameLabel.numberOfLines = 0;
        [self.BGView addSubview:self.nameLabel];
        
        self.contectLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(104),0, ZHFit(200), ZHFit(54))];
        self.contectLabel.textAlignment=NSTextAlignmentLeft;
        self.contectLabel.backgroundColor=[UIColor clearColor];
        self.contectLabel.font=fontSize(14);
        [self.BGView addSubview:self.contectLabel];
        
        self.phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(198),0, ZHFit(120), ZHFit(54))];
        self.phoneLabel.textAlignment=NSTextAlignmentLeft;
        self.phoneLabel.font=fontSize(14);
        [self.BGView addSubview:self.phoneLabel];
        
        
        self.knowLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-ZHFit(12)-ZHFit(75),0, ZHFit(75), ZHFit(54))];
        self.knowLabel.textAlignment=NSTextAlignmentRight;
        self.knowLabel.backgroundColor=[UIColor clearColor];
        self.knowLabel.font=fontSize(14);
        [self.BGView addSubview:self.knowLabel];
        
        self.cardLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(12),ZHFit(54), ZHFit(92), ZHFit(54))];
        self.cardLabel.textAlignment=NSTextAlignmentLeft;
        self.cardLabel.text=@"身份证";
        self.cardLabel.font=fontSize(14);
        [self.BGView addSubview:self.cardLabel];
        
        self.cardNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(104),ZHFit(54), ZHFit(200), ZHFit(54))];
        self.cardNumLabel.textAlignment=NSTextAlignmentLeft;
        self.cardNumLabel.backgroundColor=[UIColor clearColor];
        self.cardNumLabel.font=fontSize(14);
        [self.BGView addSubview:self.cardNumLabel];
        
    }
    
    return self;
}

/*初始化cell*/
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    ZHLinkedPeopleCell * cell =[tableView dequeueReusableCellWithIdentifier:@"linked"];
    if (cell==nil) {
        
        cell=[[ZHLinkedPeopleCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"linked"];
    }
    
    return cell;
}

/*初始化数据*/
-(void)settingCellWithValue:(NSArray*)titleArray IndexPath:(NSIndexPath*)indexPath {

    NSDictionary * infoDIc =[titleArray objectAtIndex:indexPath.row];
    self.nameLabel.text=infoDIc[@"contact_name"];
    self.contectLabel.text=[[infoDIc[@"contact_rel"] componentsSeparatedByString:@","] lastObject];
    self.phoneLabel.text=infoDIc[@"contact_mobile"];
    self.nameLabel.text=infoDIc[@"contact_name"];
    self.knowLabel.text=[self getTitleName:infoDIc[@"is_known"]];
    self.cardNumLabel.text=infoDIc[@"idcard_no"];
    
    UIView * bottomLine =[[UIView alloc]initWithFrame:CGRectMake(0, ZHFit(54)-1.0, kScreenWidth, 1.0)];
    bottomLine.backgroundColor=[UIColor colorWithRed:232/255.0 green:235/255.0 blue:237/255.0 alpha:1.0];
    [self.BGView addSubview:bottomLine];

    if ([self.contectLabel.text containsString:@"配偶"]) {
        
        self.BGView.height=ZHFit(108);
        bottomLine.y=self.BGView.height-1.0;
        UIView * line =[[UIView alloc]initWithFrame:CGRectMake(ZHFit(12), ZHFit(54), kScreenWidth-ZHFit(12)*2, 1.0)];
        line.backgroundColor=[UIColor colorWithRed:232/255.0 green:235/255.0 blue:237/255.0 alpha:1.0];
        [self.BGView addSubview:line];
    }

}

#pragma 知悉不知悉判断
-(NSString*)getTitleName:(NSString*)title{

    if ([title containsString:@"否"]) {
        
        return @"不知悉";
    }

    return @"知悉";
}

@end
