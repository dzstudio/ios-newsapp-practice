//
//  AboutUsViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : BaseViewController<UIAlertViewDelegate, WeiboResponseDelegate>

@property (strong, nonatomic) UIImage *bgImage;
@property (weak, nonatomic) IBOutlet UIView *mainMenuView;

@end
