//
//  PhotoModel.h
//  CreditSalesman
//
//  Created by 正和 on 2017/4/27.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

/** 文件ID */
@property (copy, nonatomic)  NSString *id;

/** 文件类型 */
@property (copy, nonatomic)  NSString *image_type;

/** 图片名字 */
@property (copy, nonatomic)  NSString *image_name;

/** 图片描述 */
@property (copy, nonatomic)  NSString *image_des;

/** 图片地址 */
@property (copy, nonatomic)  NSString *image_url;

/** 订单号 */
@property (copy, nonatomic)  NSString *apply_loan_key;


@end
