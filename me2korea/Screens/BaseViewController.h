//
//  BaseViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/29.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) MBProgressHUD *spinner;

- (void)showSpinner:(BOOL)show withText:(NSString *)text;
- (void)toastMessage:(NSString *)msg;
- (void)showMainMenu;

@end
