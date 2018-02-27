//
//  UIImageView+Extension.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/21.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)creatCode:(NSString *)codeContent  {
    
    //用CoreImage框架实现二维码的生成，下面方法最好异步调用
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CIFilter *codeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        //每次调用都恢复其默认属性
        [codeFilter setDefaults];
        
        // 将字符串转换成
        NSData *codeData = [codeContent dataUsingEncoding:NSUTF8StringEncoding];
        
        //设置滤镜数据
        [codeFilter setValue:codeData forKey:@"inputMessage"];
        
        //获得滤镜输出的图片
        CIImage *outputImage = [codeFilter outputImage];
        
        //这里的图像必须经过位图转换，不然会很模糊
        
        UIImage *translateImage = [self creatUIImageFromCIImage:outputImage andSize:self.bounds.size.width];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.image = translateImage;
            
        });
    });
}

//这里的size我是用imageview的宽度来算的，你可以改为自己想要的size
- (UIImage *)creatUIImageFromCIImage:(CIImage *)image andSize:(CGFloat)size {
    
    //下面是创建bitmao没什么好解释的,不懂得自行百度或者参考官方文档
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}

- (void)showBadgeWithNumber:(NSString *)number {
    
    //移除之前的小红点
    [self removeBadge];
    
    if ([number isEqualToString:@"0"] || NULLString(number)) {
        return;
    }
    
    //新建小红点
    UILabel *badgeView = [[UILabel alloc]init];
    badgeView.text = number;
    //确定小红点的位置
    CGFloat w = ZHFit(22);
    badgeView.size = CGSizeMake(w, w);
    badgeView.center = CGPointMake(self.frame.size.width - ZHFit(1), ZHFit(1));
    
    badgeView.tag = 888;
    badgeView.textColor = [UIColor whiteColor];
    badgeView.layer.cornerRadius = badgeView.size.height / 2;
    badgeView.layer.masksToBounds = YES;
    badgeView.textAlignment = NSTextAlignmentCenter;
    badgeView.backgroundColor = UIColorWithRGB(0xFF5E5E);
    [self addSubview:badgeView];
    
}

- (void)hideBadge {
    
    //移除小红点
    [self removeBadge];
}

- (void)removeBadge {
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888) {
            
            [subView removeFromSuperview];
        }
    }
}


@end
