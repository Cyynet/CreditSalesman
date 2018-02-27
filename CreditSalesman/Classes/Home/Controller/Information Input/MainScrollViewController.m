//
//  ScrollViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/15.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "MainScrollViewController.h"
#import "LoanInfoViewController.h"
#import "BasicInfoViewController.h"
#import "AdditionInfoViewController.h"
#import <SVProgressHUD.h>


@interface MainScrollViewController ()<UIScrollViewDelegate>

/**主控制器UIScrollView*/
@property (nonatomic,weak) UIScrollView *scrollView;

/**当前选中按钮*/
@property (nonatomic,weak) UIButton *selTitleButton;

/**存储标签栏按钮*/
@property (nonatomic,strong) NSMutableArray *arrTitleButtons;

/** 标题栏底部的指示器 */
@property (nonatomic, weak) UIView *sliderView;

@end

@implementation MainScrollViewController

- (NSMutableArray *)arrTitleButtons {
    if (!_arrTitleButtons) {
        _arrTitleButtons = [NSMutableArray array];
    }
    return _arrTitleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    
    //1.设置顶部右侧按钮
    [self setupNav];
    
    //2.添加滚动视图
    [self setupChildVcs];
    
    //3.添加ScrollView
    [self setupScrollView];
    
    //4.添加titleView
    [self setupTitleToolBar];
}

#pragma mark - 导航栏相关
- (void)setupNav {
    
    self.title = self.loan_type;
    
    // 导航栏右边的内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage imageNamed:@"phone"]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(clikDailBtn)];

}

#pragma mark - 添加子控制器
- (void)setupChildVcs {
    //借款资料
    LoanInfoViewController *oneVC = [[LoanInfoViewController alloc]init];
    oneVC.loanKey = self.loanKey;
    oneVC.title = @"借款资料";
    [self addChildViewController:oneVC];
    
    //基本资料
    BasicInfoViewController *twoVC = [[BasicInfoViewController alloc]init];
    twoVC.title = @"基本资料";
    [self addChildViewController:twoVC];
    
    //补充资料
    AdditionInfoViewController *threeVC = [[AdditionInfoViewController alloc]init];
    threeVC.loanKey = self.loanKey;
    threeVC.cust_no = self.cust_no;
    threeVC.title = @"补充资料";
    [self addChildViewController:threeVC];
}

#pragma mark - 设置主控制器相关
- (void)setupScrollView {
    
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建滑动视图容器
    CGRect frame = CGRectMake(0, 50, self.view.width, self.view.height - 50);
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    //设置代理
    scrollView.delegate = self;
    //设置分页效果
    scrollView.pagingEnabled = YES;
    //设置是否有弹簧效果
    scrollView.bounces = NO;
    //设置最大滚动范围
    scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 1);
    scrollView.backgroundColor = ZHBackgroundColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 添加顶部标题工具条
- (void)setupTitleToolBar {
    //设置顶部标题工具条整体
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, self.view.width, 50);
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    //为标题工具条添加按钮
    NSInteger count = self.childViewControllers.count;
    
    CGFloat buttonW = titleView.width / count;
    CGFloat buttonH = titleView.height;
    for(int index = 0; index < count;index++)
    {
        //设置按钮的x,y,w,h
        CGFloat buttonY = 0;
        CGFloat buttonX = index * buttonW;
        
        UIButton *titleButton = [[UIButton alloc]init];
        titleButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [titleButton setTitleColor:UIColorWithRGB(0xb5b5b5) forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorWithRGB(0xed6b00) forState:UIControlStateSelected];
        titleButton.titleLabel.font = fontSize(14);
        //监听按钮点击
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        [self.arrTitleButtons addObject:titleButton];
        
        //设置内容
        [titleButton setTitle:[self.childViewControllers[index] title] forState:UIControlStateNormal];
    }
    
    //设置标签栏底部的红色横线
    UIView *sliderView = [[UIView alloc]init];
    
    sliderView.height = 2;
    sliderView.y = titleView.height - 10;
    sliderView.backgroundColor = UIColorWithRGB(0xed6b00);
    sliderView.width = buttonW / 2;
    [titleView addSubview:sliderView];
    self.sliderView = sliderView;
    
    //设置第一个按钮默认选中状态
    UIButton *firstTitleButton = [self.arrTitleButtons firstObject];
    [firstTitleButton.titleLabel sizeToFit];
    
    sliderView.centerX = firstTitleButton.centerX;
    [self titleButtonClick:firstTitleButton];
}

#pragma mark - 点击标题按钮
- (void)titleButtonClick:(UIButton*)titleButton {
    
    //点击文字变色变色
    self.selTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        
//        self.sliderView.centerX = titleButton.centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.arrTitleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 点击电话按钮
- (void)clikDailBtn {
    
    if (NULLString(self.contacts_mobile)) {
        
        [SVProgressHUD showInfoWithStatus:@"电话号码不正确"];
    }else{
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.contacts_mobile];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
     }
}

#pragma mark - <UIScrollViewDelegate>

//通过代码。点击标签栏标题按钮动画结束时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    //取出对应的即将要显示的控制器
    int index = scrollView.contentOffset.x / self.view.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    //设置即将要显示控制器view的位置
    willShowChildVc.view.frame = self.scrollView.bounds;
    
    //设置控制器的view为UIScrollView的view
    [self.scrollView addSubview:willShowChildVc.view];
}

//人为拖拽。减速完毕后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    int index = scrollView.contentOffset.x / self.view.width;
    
    //移动到指定标签
    [self titleButtonClick:self.arrTitleButtons[index]];

}

// 监听滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSet = scrollView.contentOffset.x / self.childViewControllers.count;
    self.sliderView.centerX = offSet + self.view.width / 6;
}


@end
