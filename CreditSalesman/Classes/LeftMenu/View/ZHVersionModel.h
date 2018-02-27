//
//  ZHVersionModel.h
//  ZHFinancialClient
//
//  Created by zhph on 2017/4/25.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHVersionModel : NSObject

/*主键*/
@property(nonatomic,copy)NSString * ID;

/*版本名字*/
@property(nonatomic,copy)NSString * ver_name;
/*更新日期*/
@property(nonatomic,copy)NSString * update_date;
/*A：安卓；I：iOS*/
@property(nonatomic,copy)NSString * app_type;
/*版本号*/
@property(nonatomic,copy)NSString * ver_code;
/*大小*/
@property(nonatomic,copy)NSString * app_size;
/*苹果商店地址*/
@property(nonatomic,copy)NSString * appstore_url;
/*下载路径*/
@property(nonatomic,copy)NSString * url;
/*升级日志*/
@property(nonatomic,copy)NSString * ver_text;

@end
