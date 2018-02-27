//
//  ZHNavigationController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHNavigationController.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface ZHNavigationController ()

@end

@implementation ZHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 清空弹出手势的代理，就可以恢复弹出手势
//    self.interactivePopGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

+ (void)initialize {
    [self setupNavigationBar];
    [self setupBarBtnItem];
    
}

+ (void)setupNavigationBar {
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"顶部背景"] forBarMetrics:UIBarMetricsDefault];

    // title
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSForegroundColorAttributeName] = UIColorWithRGB(0x323232);
    [navBar setTitleTextAttributes:attrDict];
}

+ (void)setupBarBtnItem {
    UIBarButtonItem *barBtnItem = [UIBarButtonItem appearance];
    // nor
    NSMutableDictionary *norAttrDict = [NSMutableDictionary dictionary];
    norAttrDict[NSForegroundColorAttributeName] = UIColorWithRGB(0x323232);
    [barBtnItem setTitleTextAttributes:norAttrDict forState:UIControlStateNormal];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        
        // 默认每个push进来的控制器左右都有返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (void)showMenu {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // 只有跟控制器可以侧滑
    if (self.childViewControllers.count > 1) sender.enabled = NO;

    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}


@end
