//
//  HttpTool.h
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

/**
 *  发送一个POST请求(有加载提示)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(无载提示)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)PostWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 发送一个POST请求(文件下载)

 @param params 请求参数
 @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (void)postFileWithParams:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/**
 上传图片到服务器

 @param urlStr         请求路径
 @param params         请求参数
 @param imageData      二进制图片数据
 @param imageName      图片名字
 @param requestSuccess 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 @param requestFail    请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)UpLoadImageWithUrl:(NSString *)urlStr Params:(NSDictionary *)params Image:(NSData *)imageData ImageName:(NSString*)imageName RequsetSuccessful:(void(^)(NSURLSessionDataTask *task, id responseObject))requestSuccess RequsetFail:(void(^)(NSURLSessionDataTask *task, NSError *error))requestFail;

@end
