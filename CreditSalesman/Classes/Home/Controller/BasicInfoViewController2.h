//
//  BasicInfoViewController.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/30.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BasicInfoViewController2 : BaseTableViewController

/** 婚姻状况 已婚有子女:(007002) 未婚:(019002) */
@property (copy, nonatomic) NSString *mar_status;

@property (copy, nonatomic) NSString *mar_status_name;

/** 学历 名字+code*/
@property (copy, nonatomic) NSString *education;
/** 学历 - 名字 */
@property (copy, nonatomic) NSString *education_name;

/** QQ号 */
@property (copy, nonatomic) NSString *qq;
/** 微信号 */
@property (copy, nonatomic) NSString *wx;

/** 具体地址 */
@property (copy, nonatomic)  NSString *fullAddress;

/** 联系人 */
@property (copy, nonatomic)  NSString *contacts;

/** qq */
@property (strong, nonatomic) UITextField *qqTextField;

/** wx */
@property (strong, nonatomic) UITextField *wxTextField;


@end
