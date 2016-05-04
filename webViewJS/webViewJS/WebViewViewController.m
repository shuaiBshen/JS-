//
//  WebViewViewController.m
//  webViewJS
//
//  Created by 申帅 on 16/5/4.
//  Copyright © 2016年 申帅. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAppStoreUrl                @"http://10.223.3.139/weyoo/src/main/resources/static/appCenterV3/#/"
#define kAddAppName  @"addApp"
#define kOpenAppName @"openApp"


@interface WebViewViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(strong, nonatomic) WKWebView *webView;

@end

@implementation WebViewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //app调用js注入参数
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setUserApps(\"%@\")",@"684"] completionHandler:^(id _Nullable success, NSError * _Nullable error) {
        NSLog(@"%@",success);//如果有返回值
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpWebView];
    // Do any additional setup after loading the view.
}

- (void)setUpWebView{
    //app向web注册js协议
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:kAddAppName];
    [configuration.userContentController addScriptMessageHandler:self name:kOpenAppName];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kAppStoreUrl]]];
    [self.view addSubview:_webView];
}
//传入js
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"setUserApps(\"%@\")",@"684"] completionHandler:nil];
}

//web端js调用app方法实现协议操作
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:kAddAppName]) {
        NSDictionary *appDic = message.body;
        NSLog(@"添加app%@",appDic);
    }
    if ([message.name isEqualToString:kOpenAppName]) {
        NSString *appUrl = message.body;
        NSLog(@"打开%@",appUrl);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
