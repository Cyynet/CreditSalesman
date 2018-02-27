//
//  HelpViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/24.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "HelpViewController.h"
#import <WebKit/WebKit.h>
@interface HelpViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler> {
    BOOL _isAuth;
}
@property (nonatomic, strong) WKWebView *webView;

@property(nonatomic,strong)CALayer *progresslayer;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isAuth = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:self.webView];
    
    //进度条
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = ZHThemeColor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)respondsToBack {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        if (_isAuth) {
            if (self.authBlock) {
                self.authBlock(_isAuth);
            }
        }
        if (self.zhiMaBlock) {
            self.zhiMaBlock(_isAuth);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    
    if ([webView.title isEqualToString:@"授权成功"]) {
        _isAuth = YES;
    }
    if ([webView.title isEqualToString:@"正合信息验证"]) {
        self.title = @"运营商授权";
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        self.title = webView.title;
        if ([webView.title isEqualToString:@"正合信息验证"]) {
            self.title = @"运营商授权";
        }
    });
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"close"]) {
        _isAuth = YES;
        if (self.authBlock) {
            self.authBlock(YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"close"];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

-(void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"close"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
