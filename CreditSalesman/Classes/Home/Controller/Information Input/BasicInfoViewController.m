//
//  BasicViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/15.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "BasicInfoViewController.h"
#import "PersonInfoViewController.h"
#import "CompanyInfoViewController.h"
#import "CorporateInfoViewController.h"
#import "LinkmanInfoViewController.h"
#import "TitleMenuView.h"
@interface BasicInfoViewController ()

@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    
    //1.添加titleView
    [self setupTitleView];
    
    // 2.添加子视图
    [self setupChildVC];
    
    // 3.添加tableView组头
    UILabel *timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 54)];
    timeLabel.font = fontSize(14);
    timeLabel.textColor = UIColorWithRGB(0x8988989);
    timeLabel.backgroundColor = ZHBackgroundColor;
    timeLabel.text = [NSString stringWithFormat:@"    申请时间：%@",infoDictionary[@"insert_date"]];
    self.tableView.tableHeaderView = timeLabel;

}

#pragma mark 添加点击按钮
- (void)setupTitleView {
    
    NSArray *arr = @[@"个人信息",@"单位信息",@"联系人"];
    
    if ([infoDictionary[@"cust_type"] isEqualToString:@"2"]) {
        
        arr = @[@"个人信息",@"企业信息",@"联系人"];
    }
    
    TitleMenuView *titleView = [[TitleMenuView alloc] initWithFrame:CGRectMake(0, 54, self.view.width, 50) titleArr:arr];
    titleView.titleBlock = ^(NSInteger index){
        
        self.scrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
    };
    [self.view addSubview:titleView];
}

#pragma mark 添加滚动视图
-(void)setupChildVC {
    
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, self.view.height - 104)];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = ZHThemeColor;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    PersonInfoViewController *oneVC = [[PersonInfoViewController alloc]init];
    [self addChildViewController:oneVC];
    [scrollView addSubview:oneVC.view];
    
    //企业
    if ([infoDictionary[@"cust_type"] isEqualToString:@"2"]) {
        
        CorporateInfoViewController *twoVC = [[CorporateInfoViewController alloc]init];
        [self addChildViewController:twoVC];
        twoVC.view.x = kScreenWidth;
        [scrollView addSubview:twoVC.view];
    }else{
        CompanyInfoViewController *twoVC = [[CompanyInfoViewController alloc]init];
        [self addChildViewController:twoVC];
        twoVC.view.x = kScreenWidth;
        [scrollView addSubview:twoVC.view];
    }
    
    LinkmanInfoViewController *threeVC = [[LinkmanInfoViewController alloc]init];
    [self addChildViewController:threeVC];
    threeVC.view.x = kScreenWidth * 2;
    [scrollView addSubview:threeVC.view];
}



@end
