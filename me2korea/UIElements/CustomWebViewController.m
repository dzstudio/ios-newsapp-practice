//
//  CustomWebViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/11.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "CustomWebViewController.h"
#import "CustomNavigationBar.h"

@interface CustomWebViewController ()

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *pageTitle;
@property (nonatomic) BOOL supportLandscape;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviViewAspect;

@end

@implementation CustomWebViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUrl:(NSString *)url andTitle:(NSString *)title andSupport:(BOOL)landscape {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.pageTitle = title;
    self.supportLandscape = landscape;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.btnBack.hidden = NO;
  self.navigationBar.btnMenu.hidden = YES;
  [self.navigationBar setTitle:self.pageTitle];
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
  
  [self.navigationBar.btnBack addTarget:self action:@selector(onTapBtnBack:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadRequestWithUrl:(NSString *)url andTitle:(NSString *)title {
  self.url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  self.pageTitle = title;
  self.navigationBar.btnBack.hidden = NO;
  self.navigationBar.btnMenu.hidden = YES;
  [self.navigationBar setTitle:self.pageTitle];
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  if (SYSTEM_VERSION_LESS_THAN(@"8.0") && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
    self.naviViewAspect.constant = 300;
  } else {
    self.naviViewAspect.constant = 0;
  }
}

#pragma - mark WebView Delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self showSpinner:NO withText:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self.spinner removeFromSuperview];
  [self.webView addSubview:self.spinner];
  [self showSpinner:YES withText:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  NSString *url = webView.request.URL.absoluteString;
  NSRange weixin = [url rangeOfString:@"mp.weixin.qq.com"];
  // 去掉图文中的微信相关信息
  if (weixin.location != NSNotFound) {
    // 删除最后七个P元素
    NSString *js = @"var par = document.getElementById('js_content').getElementsByTagName('p');var sper = (par[par.length - 7]).getElementsByTagName('span');var sper2 = (par[par.length - 6]).getElementsByTagName('span');if ((sper.length > 0 && sper[0].innerHTML.indexOf('-------------') != -1) || (sper2.length > 0 && sper2[1].innerHTML.indexOf('-------------') != -1)){var del = 0;for (var i = par.length - 1; i >= 0; i--){if (del == 7) {break;} else {del++;par[i].parentNode.removeChild(par[i]);}}}";
    [webView stringByEvaluatingJavaScriptFromString:js];
  }
  
  [self showSpinner:NO withText:nil];
}

- (void)onTapBtnBack:(id) sender {
  [self dismissViewControllerAnimated:YES completion:^(void) {
    [self showSpinner:NO withText:nil];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  if (self.supportLandscape) {
    return UIInterfaceOrientationMaskAll;
  } else {
    return UIInterfaceOrientationMaskPortrait;
  }
}

@end
