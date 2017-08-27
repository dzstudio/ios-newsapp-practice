//
//  ShareMusicViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/20.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "BaseViewController.h"

@class TopMusicViewController;

@interface ShareMusicViewController : BaseViewController<WeiboResponseDelegate, UITextViewDelegate>

@property (nonatomic, strong) TopMusicViewController *topMusicController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andImage:(UIImage *)screenShot andText:(NSString *)text;

@end
