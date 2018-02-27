//
//顶部栏

#import <UIKit/UIKit.h>

@protocol TitleTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;

@end

@interface TitleTabBar : UIView

@property (nonatomic, weak)    id<TitleTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;

@property (nonatomic, strong)   NSArray     *itemTitles;

@property (nonatomic , strong)  NSMutableArray  *items;

- (id)initWithFrame:(CGRect)frame;


- (void)updateData;



@end

