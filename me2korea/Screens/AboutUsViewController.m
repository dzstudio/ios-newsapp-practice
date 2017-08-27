//
//  AboutUsViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAppVersion;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthenticate;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) WBSDKRelationshipButton *relationshipButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgRight;

- (IBAction)onTapAuthButton:(id)sender;
- (IBAction)onTapFollowButton:(id)sender;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 设置圆角
  self.logoImage.layer.masksToBounds = YES;
  self.logoImage.layer.cornerRadius = 60.0;
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  [self.btnAppVersion setTitle:[NSString stringWithFormat:@"版本号：%@", version] forState:UIControlStateNormal];
  self.menuOffset.constant = [UIScreen mainScreen].bounds.size.width;
  
  // 设置收起手势
  UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
  [self.view addGestureRecognizer:tapClose];
  UISwipeGestureRecognizer *swipeClose = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
  swipeClose.direction = UISwipeGestureRecognizerDirectionRight;
  [self.mainMenuView addGestureRecognizer:swipeClose];
  
  // 设置关注按钮
  __weak AboutUsViewController *weakself = self;
  [WeiboHelper sharedWeiboHelper]; // 初始化helper并注册app
  _relationshipButton = [[WBSDKRelationshipButton alloc] initWithFrame:CGRectMake(20, 460, 140, 30) accessToken:Preferences.wbtoken currentUser:Preferences.wbCurrentUserID followUser:DZ_UID completionHandler:^(WBSDKBasicButton *button, BOOL isSuccess, NSDictionary *resultDict) {
    if ([(NSString *)[resultDict objectForKey:@"result"] isEqualToString:@"1"]) {
      [weakself toastMessage:@"恭喜，关注成功！"];
    } else {
      [weakself toastMessage:@"哦哦，没有关注成功！"];
    }
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (![Preferences isLoggin]) {
    [self.btnAuthenticate setTitle:@"登录" forState:UIControlStateNormal];
  } else {
    [self.btnAuthenticate setTitle:@"退出" forState:UIControlStateNormal];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.backgroundImageView.image = self.bgImage;
  
  self.menuOffset.constant = [UIScreen mainScreen].bounds.size.width * 0.2;
  self.bgTop.constant = [UIScreen mainScreen].bounds.size.height * 0.05;
  self.bgBottom.constant = [UIScreen mainScreen].bounds.size.height * 0.05;
  self.bgRight.constant = [UIScreen mainScreen].bounds.size.width * 0.05;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeMenu:(UIGestureRecognizer *)gesture {
  if ([gesture isMemberOfClass:[UITapGestureRecognizer class]]) {
    if ([gesture locationInView:self.view].x >= [UIScreen mainScreen].bounds.size.width * 0.2) {
      return;
    }
  }
  
  self.menuOffset.constant = [UIScreen mainScreen].bounds.size.width;
  self.bgTop.constant = 0;
  self.bgBottom.constant = 0;
  self.bgRight.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  } completion:^(BOOL finished){
    [self dismissViewControllerAnimated:NO completion:nil];
  }];
}

- (IBAction)onTapAuthButton:(id)sender {
  if ([Preferences isLoggin]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
  } else {
    [WeiboHelper sharedWeiboHelper].wbDelegate = self;
    [[WeiboHelper sharedWeiboHelper] WBAuthorize];
  }
}

- (IBAction)onTapFollowButton:(id)sender {
  if (![Preferences isLoggin]) {
    [self toastMessage:@"请先登录"];
  } else {
    [self showSpinner:YES withText:nil];
    _relationshipButton.currentUserID = Preferences.wbCurrentUserID;
    _relationshipButton.accessToken = Preferences.wbtoken;
    _relationshipButton.followUserID = DZ_UID;
    [_relationshipButton checkCurrentRelationship];
    [_relationshipButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self showSpinner:NO withText:nil];
  }
}

- (void)hideSpinner {
  if (![Preferences isLoggin]) {
    [self.btnAuthenticate setTitle:@"登录" forState:UIControlStateNormal];
  } else {
    [self.btnAuthenticate setTitle:@"退出" forState:UIControlStateNormal];
  }
  [self showSpinner:NO withText:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex > 0) {
    [Preferences logout];
    [self showSpinner:YES withText:@"正在退出..."];
    [self performSelector:@selector(hideSpinner) withObject:nil afterDelay:2.0];
    [self.btnAuthenticate setTitle:@"关注DZ微博" forState:UIControlStateNormal];
  }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  if (![Preferences isLoggin]) {
    [self.btnAuthenticate setTitle:@"关注DZ微博" forState:UIControlStateNormal];
  } else {
    [self.btnAuthenticate setTitle:@"退出" forState:UIControlStateNormal];
  }
  [WeiboHelper sharedWeiboHelper].wbDelegate = nil;
}

@end
