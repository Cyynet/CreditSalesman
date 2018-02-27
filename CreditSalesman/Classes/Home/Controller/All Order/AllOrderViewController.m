
// 顶部导航栏
// 视图

#import "AllOrderViewController.h"
#import "TitleTabBar.h"

#import "AllViewController.h"
#import "ApplyViewController.h"
#import "CheckViewController.h"
#import "SignViewController.h"
#import "LoanViewController.h"
#import "RefuseViewController.h"
#import "CancelViewController.h"
#import "AlreadyLoanController.h"


@interface AllOrderViewController () <UIScrollViewDelegate, TitleTabBarDelegate>
{
    NSInteger       _currentIndex;
    NSMutableArray  *_titles;
    
    TitleTabBar    *_navTabBar;
    UIScrollView    *_mainView;
}

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部订单";
    
    //添加滚动视图
    [self setupChildVcs];
    //初始化子控件
    [self viewConfig];
}

#pragma mark - 添加子控制器
- (void)setupChildVcs {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _currentIndex = 1;

    _titles = [NSMutableArray arrayWithObjects:@"全部",@"申请中",@"审核中",@"已通过",@"已签约",@"放款中",@"已放款",@"已取消",@"已拒绝", nil];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    //全部
    AllViewController *oneVC = [[AllViewController alloc]init];
    oneVC.title = @"全部";
    [array addObject:oneVC];

    //申请中
    ApplyViewController *twoVC = [[ApplyViewController alloc]init];
    twoVC.title = @"申请中";
    [array addObject:twoVC];

    //审核中
    CheckViewController *threeVC = [[CheckViewController alloc]init];
    threeVC.title = @"审核中";
    [array addObject:threeVC];
    //已通过
    SignViewController *VC = [[SignViewController alloc]init];
    VC.title = @"已通过";
    VC.searchText=@"7";
    [array addObject:VC];

    //签约中
    SignViewController *fourVC = [[SignViewController alloc]init];
    fourVC.title = @"已签约";
    fourVC.searchText=@"8";
    [array addObject:fourVC];


    //放款中
    SignViewController *fiveVC = [[SignViewController alloc]init];
    fiveVC.title = @"放款中";
    fiveVC.searchText=@"9,12";
    [array addObject:fiveVC];
    
    //放款中
    AlreadyLoanController *sixVC = [[AlreadyLoanController alloc]init];
    sixVC.title = @"已放款";
    [array addObject:sixVC];
    
    //已取消
    CancelViewController *sevenVC = [[CancelViewController alloc]init];
    sevenVC.title = @"已取消";
    [array addObject:sevenVC];

    //已拒绝
    RefuseViewController *eightVC = [[RefuseViewController alloc] init];
    eightVC.title = @"已拒绝";
    [array addObject:eightVC];
    
    _subViewControllers = array;

}

- (void)viewConfig {
    [self viewInit];
    
    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = self.view.bounds;
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)viewInit {
    
    _navTabBar = [[TitleTabBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , titleHeight)];
    _navTabBar.delegate = self;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    [self.view addSubview:_navTabBar];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleHeight, kScreenWidth, kScreenHeight - titleHeight - 64)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(kScreenWidth * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
    UIView *linev = [[UIView alloc]initWithFrame:CGRectMake(0, titleHeight, kScreenWidth, 0.8)];
    linev.backgroundColor = UIColorWithRGB(0xdadada);
    [self.view addSubview:linev];
}


#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _currentIndex = scrollView.contentOffset.x / kScreenWidth;
    _navTabBar.currentItemIndex = _currentIndex;

    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * kScreenWidth, 0, kScreenWidth, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
}

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
       
        [_mainView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:NO];
    }else{
       
        [_mainView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
    }
}

@end

