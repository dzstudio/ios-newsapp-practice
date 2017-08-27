//
//  ShareMusicViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/20.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "ShareMusicViewController.h"
#import "TopMusicViewController.h"

@interface ShareMusicViewController ()

@property (weak, nonatomic) IBOutlet UIView *textViewWrapper;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) UIImage *screenShot;
@property (nonatomic, copy) NSString *initialMessage;

- (IBAction)onTapCancelButton:(id)sender;
- (IBAction)onTapPresentButton:(id)sender;

@end

@implementation ShareMusicViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andImage:(UIImage *)screenShot andText:(NSString *)text {
  if (self = [super initWithNibName:nibNameOrNil bundle:nil]) {
    self.screenShot = screenShot;
    self.initialMessage = text;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWeiboNameUpdate) name:WEIBO_USERNAME_UPDATED object:nil];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.textViewWrapper.layer.borderWidth = 1;
  self.textViewWrapper.layer.cornerRadius = 5;
  self.textViewWrapper.layer.masksToBounds = YES;
  self.textViewWrapper.layer.borderColor = [UIColor colorWithHexString:@"#72DCD6"].CGColor;
  self.shareImage.image = self.screenShot;
  self.textView.text = self.initialMessage;
  if (self.initialMessage.length > 0) {
    self.placeHolderLabel.hidden = YES;
  }
  if (Preferences.isLoggin) {
    self.labelUsername.text = Preferences.wbUsername;
  } else {
    self.labelUsername.text = @"尚未授权";
    [self.btnShare setTitle:@"授权" forState:UIControlStateNormal];
  }
  
  [self.textView becomeFirstResponder];
  
  // 自动刷新Token
  if ([[WeiboHelper sharedWeiboHelper] isAuthorizeExpired]) {
    [[WeiboHelper sharedWeiboHelper] autoRenewToken];
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  if (![text isEqualToString:@""]) {
    self.placeHolderLabel.hidden = YES;
  }
  
  if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
    self.placeHolderLabel.hidden = NO;
  }
  
  return YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)onTapCancelButton:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapPresentButton:(id)sender {
  if (self.textView.text.length <= 0 && [Preferences isLoggin]) {
    [self toastMessage:@"说点什么吧，亲！"];
    return;
  }
  
  if (![Preferences isLoggin]) {
    [self.topMusicController requestWeiboAuthorize:self.textView.text];
  } else {
    [WeiboHelper sharedWeiboHelper].wbDelegate = self;
      NSString *textWithUrl = [self.textView.text stringByAppendingString:@"  分享自#DZ韩流# 手机应用.各大应用商店搜\"DZ\""];
      
    [[WeiboHelper sharedWeiboHelper] sendTextContent:textWithUrl imageData:UIImageJPEGRepresentation(self.screenShot, 1.0)];
  }
}

#pragma mark - WeiboResponseDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  [WeiboHelper sharedWeiboHelper].wbDelegate = nil;
  if ([Preferences isLoggin]) {
    [WeiboHelper sharedWeiboHelper].wbDelegate = self;
    [[WeiboHelper sharedWeiboHelper] sendTextContent:self.textView.text imageData:UIImageJPEGRepresentation(self.screenShot, 1.0)];
  }
}

- (void)didSendWeiboPost:(id)result {
  [WeiboHelper sharedWeiboHelper].wbDelegate = nil;
  NAILog(@"Share Weibo", @"%@", result);
  if (!result) {
    [self toastMessage:@"微博发布成功！"];
    [self performSelector:@selector(onTapCancelButton:) withObject:nil afterDelay:0.6];
  } else {
    if ([[WeiboHelper sharedWeiboHelper] isAuthorizeExpired]) {
      [self.topMusicController requestWeiboAuthorize:self.textView.text];
    } else {
      [self toastMessage:@"微博发布失败，请退出后重新授权"];
    }
  }
}

/*
 由于获取微博用户名是异步的，所以这里用观察者模式动态获取更新
 */
- (void)onWeiboNameUpdate {
  self.labelUsername.text = Preferences.wbUsername;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:WEIBO_USERNAME_UPDATED object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

@end
