//
//  ZHUpgradeView.m
//  CreditSalesman
//
//  Created by zhph on 2017/5/5.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHUpgradeView.h"

#define kWindowFrame           [[UIScreen mainScreen] bounds]
#define kWindow  [[[UIApplication sharedApplication] windows] lastObject]

static ZHUpgradeView * updateView;

@interface ZHUpgradeView()
/*背景图片*/
@property(nonatomic,strong)UIImageView * imageView;

/*升级内容*/
@property(nonatomic,strong)UITextView * textView;

@end

@implementation ZHUpgradeView{

    CGFloat width;
    UIButton * clearBtn;
    UIView * bgView;
    
}

+(instancetype)shareAddUpgradeView{
    
    updateView=[[ZHUpgradeView alloc]initWithFrame:kWindowFrame];
    
    return updateView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        
        bgView =[[UIView alloc]initWithFrame:kWindowFrame];
        bgView.backgroundColor=[UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
        [self addSubview:bgView];
        
        CGFloat edgeX=ZHFit(48);
        width =ZHFit(280);
        
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(edgeX, ZHFit(88), ZHFit(280), ZHFit(435))];
        self.imageView.image=[UIImage imageNamed:@"background_img"];
        self.imageView.userInteractionEnabled=YES;
        [self addSubview:self.imageView];
        
        clearBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame=CGRectMake(kScreenWidth-ZHFit(36)-ZHFit(38), ZHFit(132), ZHFit(38), ZHFit(38));
        [clearBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [clearBtn setImage:[UIImage imageNamed:@"close_select"] forState:UIControlStateSelected];
        [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchDown];
        [self addSubview:clearBtn];
        
        UILabel * alertLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, ZHFit(180), ZHFit(280), ZHFit(18))];
        alertLabel.text=@"升级到新版本";
        alertLabel.font=fontSize(16);
        alertLabel.textColor=UIColorWithRGB(0x515151);
        alertLabel.textAlignment=NSTextAlignmentCenter;
        [self.imageView addSubview:alertLabel];
        
        self.textView=[[UITextView alloc]initWithFrame:CGRectMake(ZHFit(20), alertLabel.bottom+ZHFit(15), width-2*ZHFit(20), ZHFit(126))];
        self.textView.textAlignment=NSTextAlignmentLeft;
        self.textView.font=fontSize(14);
        self.textView.userInteractionEnabled = YES;
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.showsVerticalScrollIndicator = NO;
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.scrollEnabled = YES;
        [self.imageView addSubview:self.textView];

        UIButton * updateBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        updateBtn.backgroundColor=[UIColor colorWithRed:235/255.0 green:107/255.0 blue:31/255.0 alpha:1.0];
        [updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        updateBtn.layer.cornerRadius=ZHFit(20);
        updateBtn.titleLabel.font=fontSize(14);
        [updateBtn setTitleColor:UIColorWithRGB(0xffffff) forState:UIControlStateNormal];
        updateBtn.frame=CGRectMake(ZHFit(20), ZHFit(435)-ZHFit(60),width-2*ZHFit(20), ZHFit(40));
        [updateBtn addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchDown];
        [self.imageView addSubview:updateBtn];
  
    }
    
    return self;
    
}

- (void)setIs_coerce_update:(NSString *)is_coerce_update {

    _is_coerce_update = is_coerce_update;    
    if ([is_coerce_update isEqualToString:@"1"]) {
        
         clearBtn.hidden = YES;
    }else{
        
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearAction)];
        [bgView addGestureRecognizer:tap];
    }
}

-(void)setVersionString:(NSString *)versionString{

    _versionString=versionString;
    self.textView.text=versionString;
    //        //设置行间距和滚动范围
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = ZHFit(8);// 字体的行间距
    NSDictionary *attributes = @{NSFontAttributeName:fontSize(14),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    NSMutableAttributedString * attributeStr= [[NSMutableAttributedString alloc] initWithString:self.textView.text attributes:attributes];
    
    [attributeStr  addAttribute:NSForegroundColorAttributeName value:UIColorWithRGB(0x6e6e6e) range:NSMakeRange(0, attributeStr.length)];
    CGFloat textHight= [attributeStr boundingRectWithSize:CGSizeMake(width-2*ZHFit(20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    self.textView.attributedText = attributeStr;
    self.textView.contentSize = CGSizeMake(width-2*ZHFit(20), textHight+6);
    
    
    if (self.textView.contentSize.height <= self.textView.frame.size.height) {
        self.textView.userInteractionEnabled=NO;
    }
    
}


#pragma mark 升级按钮
-(void)updateAction{

    if (self.UpdateAppBlock) {
        
        self.UpdateAppBlock();
    }
}

#pragma mark 点击移除
-(void)clearAction{

    [self hiddenInView];
}

-(void)showInKwindow{

    [UIView animateWithDuration:0.2 animations:^{
        updateView.frame=kWindowFrame;
    }completion:^(BOOL finished) {
        
        [kWindow addSubview:updateView];
        
    }];

}

#pragma mark 移除视图
-(void)hiddenInView{

    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha=0;
      
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];

}

@end
