//
//顶部栏
//


#define SCREENW  ([UIScreen mainScreen].bounds.size.width)


#import "TitleTabBar.h"
#import "NSString+Extension.h"

#define titleWidth 80
#define titleHeight 48


@interface TitleTabBar ()
{
    UIScrollView    *_navgationTabBar;
    UIView          *_line;                 // underscore show which item selected
    NSArray         *_itemsWidth;           // an array of items' width

}
@property (nonatomic , weak) UIButton *lastBtn;

@end

@implementation TitleTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      
        [self initConfig];
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pianyiClick:) name:@"偏移" object:nil];
    }
    return self;
}


- (void)initConfig
{
    _items = [@[] mutableCopy];
  
    [self viewConfig];

}

- (void)viewConfig
{
    
    #pragma mark  scrollview
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, titleHeight)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
       
}

- (void)updateData
{
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}


- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    
    for (NSInteger index = 0; index < [_itemTitles count]; index++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize ];

        textRealSize = CGSizeMake(textRealSize.width + ZHFit(40), titleHeight);
        button.frame = CGRectMake(buttonX, 0,textRealSize.width, titleHeight);
        
        //字体颜色
        [button setTitleColor:UIColorWithRGB(0x9e9e9e) forState:UIControlStateNormal];
        [button setTitleColor:UIColorWithRGB(0xed6b00) forState:UIControlStateSelected];

        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width;
        
        if (index == 0) {
            button.selected = YES;
            self.lastBtn = button;
        }
    }
    return buttonX;
}


- (void)pianyiClick:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    int index = [noti.object intValue];
    UIButton *btn = _items[index];
    [self itemPressed:btn type:1];
}

- (void)itemPressed:(UIButton *)button type:(int)type
{
    self.lastBtn.selected = NO;
    button.selected = YES;
    self.lastBtn = button;

        
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];

}

//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        CGSize textMaxSize = CGSizeMake(SCREENW, MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:16] maxSize:textMaxSize ];
       
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
  
    return widths;
}

#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex {
    
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    
    if (button.frame.origin.x + button.frame.size.width + 50 >= SCREENW)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - SCREENW;
        if (_currentItemIndex < [_itemTitles count]-1)
        {
            offsetX = offsetX + button.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    self.lastBtn.selected = NO;
    button.selected = YES;
    self.lastBtn = button;
}

@end
