//
//  HttpTool.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "StringFilterTool.h"
#import "RSAEncryptor.h"

#define RSA_Public_key  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCMjSbRJ/jRtJOTJmmpUEaaGSpsfaFguRcC4zn7rXbm5x8r4zdzlAnCQTfa/IruOQTzM4UbkYGWRpfUCa7+a/2qCvgoOgJLR4xtJyBagsN1beCRWMI6+hTLh8BBB8lTKtXDhW0/OY4VMvms4sJDQfdokLtpdir0iaNKYYF3Qpy1TQIDAQAB"

@implementation HttpTool

+ (AFHTTPSessionManager *)manager {
    
    // 1.获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是text/html类型
    ((AFJSONResponseSerializer*)(manager.responseSerializer)).removesKeysWithNullValues = YES;
    
    // 3.声明获取到的数据格式 为JSON数据
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    // 4.设置超时时间为60s
    manager.requestSerializer.timeoutInterval = 120;
    
    return manager;
}

+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    // 5.更新网络状态
    [self updateNetWorkStatus];
    
    // 1.如果传值,转化为符合要求的字典
    if (params) {
        
        // 1.1 创建可变字典
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
        // 1.2 添加字典(业务员端需要给每个参数拼接个userType字段)
        [dictionary setObject:@"saler" forKey:@"userType"];
        // 1.3 字典转换为字符串拼接
        NSString *str = [StringFilterTool dictionaryToJson:dictionary];
        // 1.4 通过RSA给参数加密
        //        str = [RSAEncryptor encryptString:str publicKey:RSA_Public_key];
        // 1.5 拼成字典
        params = @{ @"paramJson" : str };
    }
    
    // 2.创建请求类
    AFHTTPSessionManager *manager = [self manager];
    
    // 5.设置提示框样式
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
    
    // 3.发送POST请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            //请求成功
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                [SVProgressHUD dismiss];
            }
            //调用失败,需要提示
            if ([responseObject[@"code"] isEqualToString:@"300"]) {
                
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            }
            //没有数据,不需要提示
            if ([responseObject[@"code"] isEqualToString:@"400"] || [responseObject[@"code"] isEqualToString:@"100"]) {
                
                [SVProgressHUD dismiss];
            }
            //结果回调
            success(responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            [SVProgressHUD dismiss];
            
            NSLog(@"报错:%@",error.localizedDescription);
            
            failure(error);
        }
    }];
}

//使用AFN框架来检测网络状态的改变
+ (void)updateNetWorkStatus {
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = 未知
     AFNetworkReachabilityStatusNotReachable     = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                [SVProgressHUD showInfoWithStatus:@"您已进入了没有网络的异次元"];
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showInfoWithStatus:@"您已进入了没有网络的异次元"];
                return ;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [SVProgressHUD showWithStatus:@"玩命加载中..."];
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [SVProgressHUD showWithStatus:@"玩命加载中..."];
                
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
    
    return;
}

//发送一个POST请求(无载提示)
+ (void)PostWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    // 1.如果传值,转化为符合要求的字典
    if (params) {
        
        // 1.1 创建可变字典
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
        // 1.2 添加字典(业务员端需要给每个参数拼接个userType字段)
        [dictionary setObject:@"saler" forKey:@"userType"];
        // 1.3 字典转换为字符串拼接
        NSString *str = [StringFilterTool dictionaryToJson:dictionary];
        // 1.5 拼成字典
        params = @{ @"paramJson" : str };
    }
    
    // 2.创建请求类
    AFHTTPSessionManager *manager = [self manager];
    
    // 3.发送POST请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            //结果回调
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}

+ (void)postFileWithParams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    // 1.创建请求类
    AFHTTPSessionManager *manager = [self manager];
    
    // 2.设置提示框样式
    [SVProgressHUD showWithStatus:@"图片加载中..."];
    
    NSString *urlStr = @"http://182.150.20.24:10012/zhph_commonServices/webservice/hdfs/downloadZip";
//    NSString *urlStr = @"http://61.188.178.196:8084/zhph_commonServices/webservice/hdfs/downloadZip";
    
    // 3.发送POST请求
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            [SVProgressHUD dismiss];
            
            NSDictionary *dict = responseObject;
            if (dict.count) {
                //结果回调
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
        
            [SVProgressHUD dismiss];
            NSLog(@"报错:%@",error.localizedDescription);
            failure(error);
        }
    }];
}

+ (void)UpLoadImageWithUrl:(NSString *)urlStr Params:(NSDictionary *)params Image:(NSData *)imageData ImageName:(NSString*)imageName RequsetSuccessful:(void(^)(NSURLSessionDataTask *task, id responseObject))requestSuccess RequsetFail:(void(^)(NSURLSessionDataTask *task, NSError *error))requestFail {
    
    // 1.创建请求类
    AFHTTPSessionManager *manager = [self manager];
    
    // 2.1 字典转换为字符串拼接
    NSString *str = [StringFilterTool dictionaryToJson:params];
    
    // 2.2 拼成字典
    params = @{ @"paramJson" : str };
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //设置需要上传的文件
        [formData appendPartWithFileData:imageData name:@"imageFile" fileName:imageName mimeType:@"image/jpg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showProgress:(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount) status:@"玩命上传中..."];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //调用失败,需要提示
        if ([responseObject[@"code"] isEqualToString:@"300"]) {
            
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }else{
            [SVProgressHUD dismiss];
        }
        
        //上传成功
        requestSuccess(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //上传失败
        requestSuccess(task,error);
        
    }];
    
}

@end
