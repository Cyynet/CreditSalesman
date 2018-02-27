//
//  HomeViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/3/29.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "HomeViewController.h"
#import "ZHNavigationController.h"
#import "HomeCollectionViewCell.h"
#import "NewApplyViewController.h"
#import "CustomPatchViewController.h"
#import "ProgressViewController.h"
#import "ApproveViewController.h"
#import "RefuseViewController.h"
#import "AllOrderViewController.h"
#import "HelpViewController.h"
#import "UIImageView+Extension.h"
#import <SVProgressHUD.h>


@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** collectionView */
@property(nonatomic,strong) UICollectionView * collectionView;

/** 标题数组 */
@property (strong, nonatomic) NSArray *titles;

/** 代办任务数 */
@property (copy, nonatomic)  NSString *messageCount;

@end

static NSString * const ID = @"indentify";

@implementation HomeViewController

- (NSArray *)titles {
    
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"生成二维码",@"客户补件",@"进度查询",@"审批通过件",@"审批拒绝件",@"全部订单",@"我的业绩",@"帮助中心", nil];
    }
    return _titles;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 1; //横向
        flowLayout.minimumLineSpacing = 1;//纵向
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView = collectionView;
        
#pragma mark -- 注册单元格
        [collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:ID];
     }
    
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //0.请求代办消息数
    [self requsetMessageCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正好贷";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //1. 添加导航栏左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"个人中心"] style:UIBarButtonItemStylePlain target:(ZHNavigationController *)self.navigationController action:@selector(showMenu)];
    
    // 2. 创建页面
    [self.view addSubview:self.collectionView];

}

- (void)requsetMessageCount {
    
    NSDictionary *params = @{
                             @"saler_no":[kUserDefaults valueForKey:@"saler_no"],
                             @"audit_status":@"1,6",
                             @"pageIndex":@"1",
                             @"pageSize":@"5"
                             };
    
    [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetAllLoanByStateOnSaler.spring",kOuternet] params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            //代办任务数
            self.messageCount = responseObject[@"data"][@"count"];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
        }
        
        NSLog(@"消息数%@",responseObject[@"data"][@"count"]);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.iconView.image = [UIImage imageNamed:self.titles[indexPath.row]];
    cell.desLabe.text = self.titles[indexPath.row];
    
    if (indexPath.row == 1) {
        [cell.iconView showBadgeWithNumber:self.messageCount];
    }
    return cell;
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController;
    
    switch (indexPath.row) {
            
        case 0:{
            
            /** 生成二维码 */
            viewController = [[NewApplyViewController alloc]init];
            break;
        }
        case 1:{
            
            /** 客户补件 */
            viewController = [[CustomPatchViewController alloc]init];
            break;

        }
        case 2:{
            
            /** 进度查询 */
            viewController = [[ProgressViewController alloc]init];
            break;
        }
        case 3:{
            
            /** 审批通过件 */
            viewController = [[ApproveViewController alloc]init];
            break;
        }
        case 4:{
            
            /** 审批拒绝件 */
            viewController = [[RefuseViewController alloc]init];
            ((RefuseViewController *)viewController).showSearchBar = YES;
            break;
        }
        case 5:{
            
            /** 全部订单 */
            viewController = [[AllOrderViewController alloc] init];
            break;
        }
        case 6:{
            
            /** 我的业绩 */
            [SVProgressHUD showInfoWithStatus:@"敬请期待"];
            break;
        }
        case 7:{
            
            /** 帮助中心 */
            viewController = [[HelpViewController alloc]init];
            ((HelpViewController *)viewController).urlString = [NSString stringWithFormat:@"%@H5Pages/help_center/help.html",kOuternet];
            break;
        }
            
        default:
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - UICollectionViewDelegateFlowLayout
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.view.width - 1) / 2;
    CGFloat height = (kScreenHeight - 3 - 64) / 4;
    CGFloat kScale = height / width;
    
    return CGSizeMake(width, width * kScale);
}

@end
