//
//  ZHProgressTableViewCell.m
//  CreditSalesman
//
//  Created by zhph on 2017/4/27.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHProgressTableViewCell.h"
#import "ZHProgressModel.h"

@interface ZHProgressTableViewCell()

/*状态图标*/
@property(nonatomic,strong)UIImageView * iconImageView;
/*状态label*/
@property(nonatomic,strong)UILabel * statusLabel;
/*时间label*/
@property(nonatomic,strong)UILabel * dateLabel;
/*进度线*/
@property(nonatomic,strong)UIView * lineView;

@end

@implementation ZHProgressTableViewCell{

    /*上面的线*/
    UIView *verticalLineTopView;
    /*上面的线*/
    UIView *verticalLineBottomView;
    
    /*小图片的大小*/
    CGFloat smallSize;
    /*大图片的大小*/
    CGFloat largeSize;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        smallSize=ZHFit(10);
        largeSize=ZHFit(20);
        
        self.statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(52), ZHFit(30), ZHFit(600), ZHFit(15))];
        self.statusLabel.textColor=UIColorWithRGB(0x9f9f9f);
        self.statusLabel.font=fontSize(14);
        [self.contentView addSubview:self.statusLabel];
        
        self.dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(52), self.statusLabel.bottom+ZHFit(10), ZHFit(200), ZHFit(12))];
        self.dateLabel.textColor=UIColorWithRGB(0x9f9f9f);
        self.dateLabel.font=fontSize(12);
        [self.contentView addSubview:self.dateLabel];

        self.iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(largeSize-smallSize/2, ZHFit(30), smallSize, smallSize)];
        self.iconImageView.image=[UIImage imageNamed:@"before"];
        [self.contentView addSubview:self.iconImageView];
        
        verticalLineTopView = [[UIView alloc] initWithFrame:CGRectMake(ZHFit(20), 0, 1.0, self.iconImageView.bottom-smallSize)];
        verticalLineTopView.backgroundColor = UIColorWithRGB(0xd2d2d2);
        [self addSubview:verticalLineTopView];
        
        verticalLineBottomView = [[UIView alloc] initWithFrame:CGRectMake(ZHFit(20), self.iconImageView.bottom, 1.0, ZHFit(86)-self.iconImageView.bottom)];
        verticalLineBottomView.backgroundColor = UIColorWithRGB(0xd2d2d2);
        [self addSubview:verticalLineBottomView];
        
    }
    
    return self;

}

#pragma mark 获取title
-(NSString*)getTitle:(NSInteger)auditState{
    
    NSString * title=nil;
    
    switch (auditState) {
            
        case 0://完善资料
            title=@"完善资料";
            break;
        case 1://销售确认
            title=@"销售确认";
            break;
        case 2://审核中
            title=@"审核中";
            break;
        case 3://已放弃
            title=@"已放弃";
            break;
        case 4://已取消
            title=@"已取消";
            break;
        case 5://已拒绝 业务端直接拒绝
            title=@"已拒绝";
        case 11://已拒绝 信审不通过
            title=@"已拒绝";
            break;
        case 6://资料补充
            title=@"资料补充";
            break;
        case 7://审核通过
            title=@"审核通过";
            break;
        case 8://面签
            title=@"面签";
            break;
        case 9://提现中
            title=@"提现中";
            break;
        case 10://已放款
            title=@"已放款";
            break;
        default:
            break;
            
    }
    
    return title;
}

/*创建cell*/
+ (instancetype)dequeueReusableCellWithTableView:(UITableView*)tableView  Identifier:(NSIndexPath *)indexPath{

    ZHProgressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (cell==nil) {
        
        cell=[[ZHProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//赋值
- (void)setDataSource:(NSArray*)titleArray isFirst:(BOOL)isFirst isLast:(BOOL)isLast IndexPath:(NSIndexPath*)indexPath {
    
    //设置最上面和最下面是否隐藏
    verticalLineTopView.hidden = isFirst;
    verticalLineBottomView.hidden = isLast;
    
    if (indexPath.row==0) {
        self.iconImageView.size=CGSizeMake(largeSize, largeSize);
        self.iconImageView.image=[UIImage imageNamed:@"current"];
        self.iconImageView.x=largeSize-largeSize/2;
        verticalLineBottomView.y=self.iconImageView.bottom;
        verticalLineTopView.height=ZHFit(86)-self.iconImageView.bottom;
    }
    
    ZHProgressModel * model =[titleArray objectAtIndex:indexPath.row];
//    self.statusLabel.text = [self getTitle:[model.loan_state integerValue]];
    self.statusLabel.text = model.loan_result;
    self.dateLabel.text=model.insert_date;
}


@end
