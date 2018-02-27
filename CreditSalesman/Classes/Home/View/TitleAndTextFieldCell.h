//
//  TitleAndTextFieldCell.h
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/13.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleAndTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *title;                       //标题
@property(nonatomic,strong)UITextField *detail;                  //信息
@property(nonatomic,strong)UIView *line;                         //分割线

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);


@end
