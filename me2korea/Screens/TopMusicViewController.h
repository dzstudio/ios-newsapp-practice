//
//  TopMusicViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMusicViewController : BaseViewController<UIScrollViewDelegate, WeiboResponseDelegate>

- (IBAction)onTapLeftArrow:(id)sender;
- (IBAction)onTapRightArrow:(id)sender;

- (void)showNewsTipIcon;
- (void)hideNewsTipIcon;
- (void)requestWeiboAuthorize:(NSString *)tempMsg;

@end
