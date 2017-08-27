//
//  BaseViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/29.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "BaseViewController.h"
#import "AboutUsViewController.h"
#import "UIView+Screenshot.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AnalyticsHelper beginLogPageView:[self getPageName]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AnalyticsHelper endLogPageView:[self getPageName]];
}

- (NSString*)getPageName {
    return [NSString stringWithUTF8String:object_getClassName(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Properties
- (MBProgressHUD *)spinner {
  if (!_spinner) {
    _spinner = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_spinner];
  }
  
  return _spinner;
}

/*
 显示和隐藏模态进度圈
 */
- (void)showSpinner:(BOOL)show withText:(NSString *)text {
  if (show) {
    [self.spinner setMode:MBProgressHUDModeIndeterminate];
    [self.spinner setLabelText:text];
    [self.spinner show:YES];
  } else {
    [self.spinner hide:NO];
  }
}

/*
 展示toast消息
 */
- (void)toastMessage:(NSString *)msg {
  dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.spinner setMode:MBProgressHUDModeText];
    [self.spinner setLabelText:msg];
    [self.spinner show:YES];
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:0.6];
  });
}

/*
 展示侧滑菜单
 */
- (void)showMainMenu {
  M2AppDelegate.aboutUsViewController.bgImage = [M2AppDelegate.window screenshot];
  [self presentViewController:M2AppDelegate.aboutUsViewController animated:NO completion:nil];
}

- (void)hideToast {
  [self.spinner hide:YES];
}

@end
