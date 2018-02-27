//
//  UIButton+Extension.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/21.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

#pragma mark 内部类 MYExButton
@interface MYExButton : UIButton
@property (copy, nonatomic) TapButtonActionBlock action;
@end



@implementation MYExButton

- (instancetype)init
{
    if(self = [super init])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnClick:(UIButton *)button
{
    if(self.action)
    {
        self.action(self);
    }
}


@end


//保留第一次点击
BOOL isFirst;

@interface UIButton()

@property (nonatomic, assign) NSTimeInterval custom_acceptEventTime;

@end

@implementation UIButton (Extension)

+ (void)load{
    
    isFirst=YES;
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method customMethod = class_getInstanceMethod(self, @selector(custom_sendAction:to:forEvent:));
    SEL customSEL = @selector(custom_sendAction:to:forEvent:);
    
    //添加方法 语法：BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types) 若添加成功则返回No
    // cls：被添加方法的类  name：被添加方法方法名  imp：被添加方法的实现函数  types：被添加方法的实现函数的返回值类型和参数类型的字符串
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    
    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, customMethod);
        
    }
}

- (NSTimeInterval )custom_acceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )custom_acceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setCustom_acceptEventTime:(NSTimeInterval)custom_acceptEventTime{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    // 值得提醒一下：如果这里设置了统一的时间间隔，会影响UISwitch,如果想统一设置，又不想影响UISwitch，建议将UIControl分类，改成UIButton分类，实现方法是一样的
    // if (self.custom_acceptEventInterval <= 0) {
    //     // 如果没有自定义时间间隔，则默认为2秒
    //    self.custom_acceptEventInterval = 2;
    // }
    
    // 是否小于设定的时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_acceptEventTime >= self.custom_acceptEventInterval);
    
    // 更新上一次点击时间戳
    if (needSendAction||isFirst) {
        self.custom_acceptEventTime = NSDate.date.timeIntervalSince1970;
//        NSLog(@"被设置新的时间");
    }
    
    isFirst=NO;
//    NSLog(@"上一次点击的时间%f",self.custom_acceptEventTime);
//    NSLog(@"可以接受的时间%f",self.custom_acceptEventInterval);
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self custom_sendAction:action to:target forEvent:event];
//        NSLog(@"发送点击事件");
    }
    
    
}

//  创建普通按钮
+ (instancetype)addCustomButtonWithFrame:(CGRect)frame
                                   title:(NSString *)title
                         backgroundColor:(UIColor *)backgroundColor
                              titleColor:(UIColor *)titleColor
                               tapAction:(TapButtonActionBlock)tapAction
{
    MYExButton *btn = [MYExButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.action = tapAction;
    btn.layer.cornerRadius = 0.5*frame.size.height;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

@end
