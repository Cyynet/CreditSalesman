//
//  AppDelegate.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "REFrostedViewController.h"
#import "LoginViewController.h"
#import "ZHUpgradeView.h"
#import "StringFilterTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1 创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //2 初始化根控制器
    [self setupRootController];
    
    //3 成为主窗口并显示
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark 选择根控制器
- (void)setupRootController {
    
    /**判断是否是第一次启动  从缓存中获取到用户的ID就让用户直接登录  */
    if([kUserDefaults valueForKey:@"saler_no"]){
        
        //2.1创建首页和侧滑菜单 controllers
        ZHNavigationController *navigationController = [[ZHNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
        self.navigationController = navigationController;
        LeftMenuViewController *menuController = [[LeftMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //2.2创建 frosted view controller
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        frostedViewController.menuViewSize = CGSizeMake(kScreenWidth * 0.73, kScreenHeight);
        frostedViewController.liveBlur = YES;
        frostedViewController.limitMenuViewSize = YES;
        
        //2.3成为根控制器
        self.window.rootViewController = frostedViewController;
    }else{
        
        // 2.4 去登录界面
        ZHNavigationController *nav = [[ZHNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        self.window.rootViewController = nav;
    }
}

#pragma mark 检查更新
- (void)applicationDidBecomeActive:(UIApplication *)application {

//    NSLog(@"%s", __func__);
    
    // 1.1 从plist中取出版本号
    NSString *version = [StringFilterTool getCurrentVersion];
    
    // 1.2 从服务器获取最新的版本号
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@CheckUpdate.spring",kOuternet] params:@{@"app_type":@"I"} success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            NSString *currentVersion = responseObject[@"data"][@"ver_code"];
            
            //版本号不一样：第一次使用新版本
            BOOL update = [version compare:currentVersion options:NSNumericSearch] == NSOrderedAscending;
            
            if (update) {
                
                ZHUpgradeView * VersionView = [ZHUpgradeView shareAddUpgradeView];
                [VersionView showInKwindow];
                VersionView.is_coerce_update = responseObject[@"data"][@"is_coerce_update"];
                VersionView.versionString = [responseObject[@"data"][@"ver_text"] stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
                VersionView.UpdateAppBlock = ^{
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kOuternet,responseObject[@"data"][@"url"]]]];
                };
            }
        }
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];

}

@end
