//
//  CustomWebViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/11.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomWebViewController : BaseViewController<UIWebViewDelegate>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUrl:(NSString *)url andTitle:(NSString *)title andSupport:(BOOL)landscape;
- (void)loadRequestWithUrl:(NSString *)url andTitle:(NSString *)title;

@end
