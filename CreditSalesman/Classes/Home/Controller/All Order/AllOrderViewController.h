
// 顶部导航栏
//

#import <UIKit/UIKit.h>

#define titleHeight 48

@class SCNavTabBar;

@interface AllOrderViewController : UIViewController

@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO

@property (nonatomic, strong)   NSMutableArray *subViewControllers;

@end


