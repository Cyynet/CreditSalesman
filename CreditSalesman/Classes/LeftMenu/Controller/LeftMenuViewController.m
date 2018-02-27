//
//  LeftMenuViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ChangPwViewController.h"
#import "REFrostedViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "ZHNavigationController.h"
#import "LoginViewController.h"
#import "UIAlertViewTool.h"
#import "StringFilterTool.h"
#import "AppDelegate.h"
#import "VersionViewController.h"
@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *titles;

@end

@implementation LeftMenuViewController

- (NSArray *)titles {
    if (!_titles) {
        
        _titles = [NSArray arrayWithObjects:@"修改密码",@"版本记录", nil];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //去掉多余的表格线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //组头
    self.tableView.tableHeaderView = ({
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 210.0f)];
        view.image = [UIImage imageNamed:@"top_img"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 54, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"head_portrait"];
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 0, 24)];
        
        NSString *saler_name = [kUserDefaults objectForKey:@"saler_name"];
        label.text = NULLString(saler_name) ? @"信贷专员" : saler_name;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = UIColorWithRGB(0xffffff);
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    //组尾
    self.tableView.tableFooterView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kScreenHeight - 318)];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
        lineLabel.backgroundColor = UIColorWithRGB(0xdadada);
        lineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [view addSubview:lineLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 56, ZHFit(228), 44)];
        btn.backgroundColor = ZHThemeColor;
        btn.layer.cornerRadius = 0.5 * btn.height;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"退出" forState:UIControlStateNormal];
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [btn addTarget:self action:@selector(signOut) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 318 - 36, 0, 12)];
        label.text = [NSString stringWithFormat:@"当前版本号：%@",[StringFilterTool getCurrentVersion]];
        label.textColor = UIColorWithRGB(0xbcbcbc);
        label.font = fontSize(14);
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
        [view addSubview:label];
        view;

    });
}

#pragma mark - 退出账号
- (void)signOut {
    
    [UIAlertViewTool showAlertView:self title:nil message:@"确定退出" cancelTitle:@"取消" otherTitle:@"确认" cancelBlock:^{
        
    } confrimBlock:^{
        
        //移除存储的数据
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [kUserDefaults removePersistentDomainForName:appDomain];
        //重新设置根控制器
        ZHNavigationController *nav = [[ZHNavigationController alloc] initWithRootViewController:[LoginViewController alloc]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = nav;
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    cell.imageView.image = [UIImage imageNamed:[self.titles objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /** 访问AppDelegate全局变量 */
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    if (indexPath.row == 1) {
        
        VersionViewController *VC = [[VersionViewController alloc] init];
        [appDelegate.navigationController pushViewController:VC animated:YES];
    }else{
    
        ChangPwViewController *VC = [[ChangPwViewController alloc] init];
        [appDelegate.navigationController pushViewController:VC animated:YES];
    }
    
    [self.frostedViewController hideMenuViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 54;
}

/*
 @brief 分割线左对齐
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //按照作者最后的意思还要加上下面这一段
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

@end
