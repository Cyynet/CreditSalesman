//
//  QRCodeViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/13.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIImageView+Extension.h"

@interface QRCodeViewController ()

/** 二维码 */
@property (strong, nonatomic)  UIImageView *codeImageView;

/** 二维码视图 */
@property (strong, nonatomic)  UIView *qrCodeView;

/** 扫一扫上面二维码 */
@property(nonatomic, strong)   UILabel *desLabel;

/** 长按保存二维码 */
@property(nonatomic, strong)   UILabel *saveLabel;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
    //设置后，控制器的view的frame的坐标Y增加64px紧挨着navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = ZHBackgroundColor;
    
    [self setupTopViews];
    
    //二维码
    [self.codeImageView creatCode:self.codeStr];
    //扫一扫上面二维码
    self.desLabel.text = @"扫一扫上面二维码，立即贷款";
    //长按保存二维码
    self.saveLabel.text = [NSString stringWithFormat:@"长按保存二维码，二维码有效时间为%@天",self.dic_value];
 
}

- (void)setupTopViews {
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, self.view.width, 66);
    topView.backgroundColor = UIColorWithRGB(0xfff2c8);
    [self.view addSubview:topView];
    
    UILabel *productLabel = [[UILabel alloc] init];
    productLabel.font = [UIFont systemFontOfSize:14];
    productLabel.textColor = UIColorWithRGB(0x292929);
    productLabel.frame = CGRectMake(10, 15, self.view.width / 2 - 10, 11);
    productLabel.text = [NSString stringWithFormat:@"产品类型：%@",self.product_name];
    [topView addSubview:productLabel];
    
    NSMutableAttributedString *productStr = [[NSMutableAttributedString alloc] initWithString:productLabel.text];
    [productStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5,productStr.length - 5)];
    productLabel.attributedText = productStr;
    
    
    UILabel *preiodLabel = [[UILabel alloc] init];
    preiodLabel.font = [UIFont systemFontOfSize:14];
    preiodLabel.textColor = UIColorWithRGB(0x292929);
    preiodLabel.textAlignment = NSTextAlignmentRight;
    preiodLabel.frame = CGRectMake(self.view.width / 2, productLabel.y, self.view.width / 2 - 10, productLabel.height);
    preiodLabel.text = [NSString stringWithFormat:@"借款期数：%@期",self.productTerm];
    [topView addSubview:preiodLabel];
    
    NSMutableAttributedString *preiodStr = [[NSMutableAttributedString alloc] initWithString:preiodLabel.text];
    [preiodStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5,preiodStr.length - 5)];
    preiodLabel.attributedText = preiodStr;

    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = fontSize(14);
    moneyLabel.textColor = UIColorWithRGB(0x292929);
    moneyLabel.frame = CGRectMake(10, productLabel.bottom + 12, self.view.width , productLabel.height);
    moneyLabel.text = [NSString stringWithFormat:@"借款金额：%@0000元",self.loanMoney];
    [topView addSubview:moneyLabel];
    
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:moneyLabel.text];
    [moneyStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5,moneyStr.length - 5)];
    moneyLabel.attributedText = moneyStr;

}

//二维码图片
- (UIImageView *)codeImageView {
    
    if (!_codeImageView) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = YES;
        bgView.frame = CGRectMake((self.view.width - ZHFit(260)) / 2, ZHFit(136), ZHFit(260), ZHFit(260));
        bgView.backgroundColor = UIColorWithRGB(0xffffff);
        [self.view addSubview:bgView];
        
        _codeImageView = [[UIImageView alloc] init];
        _codeImageView.frame = CGRectMake(ZHFit(20), ZHFit(20), ZHFit(220), ZHFit(220));
        //图片拉伸至完全显示在UIImageView里面为止(图片不会变形)
        _codeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _codeImageView.userInteractionEnabled = YES;
        [bgView addSubview:_codeImageView];
        
        //长按保存图中的二维码，二维码有效时间为1天
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePictureToAlbum)];
        [self.codeImageView addGestureRecognizer:longPress];

    }
    return _codeImageView;
}

//扫一扫上面二维码，立即贷款
- (UILabel *)desLabel {
    if (!_desLabel)
    {
        _desLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, ZHFit(430), self.view.width, 15)];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font  = fontSize(14);
        _desLabel.textColor = UIColorWithRGB(0x626262);
        [self.view addSubview:_desLabel];
    }
    return _desLabel;
}

//长按保存二维码提示
- (UILabel *)saveLabel {
    if (!_saveLabel)
    {
        _saveLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 24 - 15, self.view.width, 15)];
        _saveLabel.textAlignment = NSTextAlignmentCenter;
        _saveLabel.font  = fontSize(14);
        _saveLabel.textColor = UIColorWithRGB(0xa5a5a5);
        [self.view addSubview:_saveLabel];
    }
    return _saveLabel;
}

#pragma mark - ******************** 保存到相册方法
- (void)savePictureToAlbum {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(self.codeImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }]];
  
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleName"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存图片被阻止了" message:[NSString stringWithFormat:@"请到系统->“设置”->“隐私”->“照片”中开启“%@”访问权限",appName] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已保存至照片库"delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] ;
        [alertView show];
    }
}

@end
