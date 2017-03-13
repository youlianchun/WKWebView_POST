//
//  ViewController.m
//  WKWebView_POST
//
//  Created by YLCHUN on 2017/3/13.
//  Copyright © 2017年 ylchun. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, retain) WKWebView *webView;

@end

@implementation ViewController
-(WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view insertSubview:_webView atIndex:0];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_webView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.backgroundColor = [UIColor whiteColor];

    NSString *urlString = @"https://api.upbox.com.cn/upboxApi/match_getRecommendMatch.do";
    NSDictionary *params = @{@"userStatus":@"-1",@"resource":@"2",@"token":@"",@"appCode":@"2.2.0"};
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:[[self postParams:params] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request]; 
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSString*)postParams:(NSDictionary*)params{
    NSArray *allKeys = params.allKeys;
    if(allKeys.count==0){
        return @"";
    }
    NSMutableArray *keyValue = [NSMutableArray array];
    for (NSString* key in allKeys) {
        [keyValue addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
    }
    NSString* param = [keyValue componentsJoinedByString:@"&"];
    return param;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //POST请求 打印出来的请求是没有参数的
    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// https 支持
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    NSLog(@"https证书");
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}
@end
