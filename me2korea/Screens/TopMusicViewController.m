//
//  TopMusicViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "TopMusicViewController.h"
#import "ToptenPagerView.h"
#import "CustomNavigationBar.h"
#import "ShareMusicViewController.h"

#define TIP_ICON_TAG 33

@interface TopMusicViewController () {
  NSInteger currentPageIndex;
  UIImage *_tempWeiboImage;
  NSString *_tempWeiboMessage;
  ShareMusicViewController *_shareViewController;
}

@property (weak, nonatomic) IBOutlet UIButton *btnPrevArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnNextArrow;

@property (nonatomic, strong) NSArray *pageConfig;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet UILabel *subPageTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;
@property (nonatomic, strong) NSMutableDictionary *updatableValue;

@end

@implementation TopMusicViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _pageConfig = @[@{@"title": @"melon", @"action": TOPTENSID_MELON},
                    @{@"title": @"naver", @"action": TOPTENSID_NEVER},
                    @{@"title": @"mnet", @"action": TOPTENSID_MNET},
                    @{@"title": @"bugs", @"action": TOPTENSID_BUGS},
                    //@{@"title": @"daum", @"action": TOPTENSID_DAUM},
                    @{@"title": @"Hanteo专辑销量（实时）", @"action": TOPTENSID_HANTEO_REAL},
                    @{@"title": @"Hanteo专辑销量（每日）", @"action": TOPTENSID_HANTEO_DAY},
                    @{@"title": @"每周音源&舞台总结", @"action": TOPTENSID_WEEK},
                    @{@"title": @"最新热门专辑", @"action": TOPTENSID_LATEST}];
      
    _updatableValue = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        @"false", TOPTENSID_MELON,
                        @"false", TOPTENSID_NEVER,
                        @"false", TOPTENSID_MNET,
                        @"false", TOPTENSID_BUGS,
                        @"false", TOPTENSID_HANTEO_REAL,
                        @"false", TOPTENSID_HANTEO_DAY,
                        @"false", TOPTENSID_LATEST,
                        @"false", TOPTENSID_WEEK,
                        nil];
  }
    
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationBar setTitle:@"音乐排行榜"];
  self.navigationBar.btnShare.hidden = NO;
  [self showSpinner:YES withText:@"正在加载..."];
  [self.navigationBar.btnShare addTarget:self action:@selector(onTapShareBtn:) forControlEvents:UIControlEventTouchUpInside];
  [self.navigationBar.btnMenu addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self showSpinner:NO withText:nil];
  // 初始化榜单页面
  if (!_pages) {
    CGFloat offsetLeft = 0;
    currentPageIndex = -1; // 初始化页面
    _pages = [NSMutableArray array];
    
    for (NSDictionary *page in self.pageConfig) {
      CGRect pageFrame = (CGRect){offsetLeft, 0, self.pagerScrollView.frame.size};
      offsetLeft += self.view.frame.size.width;
      ToptenPagerView *pagerView = [[ToptenPagerView alloc] initWithFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"action"]];
      [self.pages addObject:pagerView];
      [self.pagerScrollView addSubview:pagerView];
      [self.pagerScrollView setContentSize:CGSizeMake(offsetLeft, self.pagerScrollView.frame.size.height)];
    }
    
    [self configCurrentPage];
  }
}

/*
 设置当前页面
 */
- (void)configCurrentPage {
  NSInteger index = (NSInteger)ceilf(self.pagerScrollView.contentOffset.x / self.pagerScrollView.frame.size.width);
  
  if (index == currentPageIndex) {
    // 没有切换页面，不做任何事情
    return;
  }
  
  currentPageIndex = index;
  ToptenPagerView *pageView = [self.pages objectAtIndex:index];
  self.subPageTitle.text = pageView.title;
  
  // 隐藏左右切换的图标
  self.btnPrevArrow.hidden = NO;
  self.btnNextArrow.hidden = NO;
  if (currentPageIndex == 0) {
    self.btnPrevArrow.hidden = YES;
  } else if (currentPageIndex == (self.pages.count - 1)) {
    self.btnNextArrow.hidden = YES;
  }
  
  if ([pageView.tableView numberOfRowsInSection:0] <= 0 || [Constants.autoRefreshPagers containsObject:NSStringFromClass(pageView.class)]) {
    // 第一次初始化时，本地没有数据，需要加载一次
    [pageView loadFirstPageData];
  }
  
  // 配置红色图标
  // 1. Set default value: no red point
  [self hideNewsTipIcon];
  // 2. Check update on server
  [self checkUpdate:pageView];
}

- (void) checkUpdate:(ToptenPagerView *)pageView {
    NSInteger timepass = 0;
    if ([pageView.type isEqualToString:TOPTENSID_HANTEO_DAY]) { // 每日
        timepass = 86400;
    } else if ([pageView.type isEqualToString:TOPTENSID_HANTEO_REAL]) { // 实时
        timepass = 60 * 30;
    } else { // 每小时
        timepass = 60 * 60;
    }
    
    // pageView.lastLoadTime format is : time = "2015-11-01 10:00:00". It is KOREA time!!! because server is in Korea.
    NSTimeInterval aHour = - 60 * 60;
    NSDate *currentChinaDate = [NSDate dateWithTimeInterval:aHour sinceDate:pageView.lastLoadTime];
 
    // 需要调用API去服务器获取最新状态
    if (!pageView.lastLoadTime || [[NSDate date] timeIntervalSinceDate:currentChinaDate] >= timepass) {
        [[APIProcessor instance] checkToptenzUpdateWithSite:pageView.type andTime:pageView.lastLoadTime andSuccess:^(NSArray *res) {
            
            NSString *show = [res[0] objectForKey:@"has_new"];
            if([[self.updatableValue allKeys] containsObject:pageView.type]){
                [self.updatableValue setObject:show forKey:pageView.type];
            }
            [self configRedPoint:pageView];
            
        } andFailure:^(NSError *error){
            [self configRedPoint:pageView];
        }];
    } else {
        //[self configRedPoint:pageView];
    }
}

- (void) configRedPoint:(ToptenPagerView *)pageView {
    NSString* status = [self.updatableValue objectForKey:pageView.type];
    if([status caseInsensitiveCompare:@"true"] == NSOrderedSame) {
        [self showNewsTipIcon];
    } else {
        [self hideNewsTipIcon];
    }
}

#pragma mark - Delegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self performSelector:@selector(configCurrentPage) withObject:nil afterDelay:0.3];
}

#pragma mark - User Events
- (IBAction)onTapRightArrow:(id)sender {
  NSInteger index = currentPageIndex + 1;
  
  // 如果不是最后一页，则调到下一页
  if (index < self.pages.count) {
    UIView *page = [self.pages objectAtIndex:currentPageIndex];
    CGRect frame = page.frame;
    frame.origin.x += self.pagerScrollView.frame.size.width;
    [self.pagerScrollView scrollRectToVisible:frame animated:YES];
    [self performSelector:@selector(configCurrentPage) withObject:nil afterDelay:0.3];
  }
}

- (IBAction)onTapLeftArrow:(id)sender {
  NSInteger index = currentPageIndex - 1;
  
  // 如果不是第一页，则调到上一页
  if (index >= 0) {
    UIView *page = [self.pages objectAtIndex:currentPageIndex];
    CGRect frame = page.frame;
    frame.origin.x -= self.pagerScrollView.frame.size.width;
    [self.pagerScrollView scrollRectToVisible:frame animated:YES];
    [self performSelector:@selector(configCurrentPage) withObject:nil afterDelay:0.3];
  }
}

- (void)onTapShareBtn:(id) sender {
  // 生成当前屏幕截图
  UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0.0); // get context that can be used to process images graphics
  [M2AppDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
  _tempWeiboImage = UIGraphicsGetImageFromCurrentImageContext(); // get a UIImage object from the current context
  UIGraphicsEndImageContext(); // Close UIImage context
  _tempWeiboMessage = @"";
  
  _shareViewController = [[ShareMusicViewController alloc] initWithNibName:@"ShareMusicViewController" andImage:_tempWeiboImage andText:_tempWeiboMessage];
  _shareViewController.topMusicController = self;
  [[M2AppDelegate window].rootViewController presentViewController:_shareViewController animated:YES completion:nil];
}

/*
 控制分享页面上的授权, 需要先缓存图片和文字信息，然后关闭分享页面。
 */
- (void)requestWeiboAuthorize:(NSString *)tempMsg {
  _tempWeiboMessage = tempMsg;
  [_shareViewController dismissViewControllerAnimated:NO completion:^() {
    [WeiboHelper sharedWeiboHelper].wbDelegate = self;
    [[WeiboHelper sharedWeiboHelper] WBAuthorize];
  }];
}

- (void)showNewsTipIcon {
  [self hideNewsTipIcon];
  
  // 如果没有网络则隐藏红点
  if (![Utils instance].isNetworkRunning) {
    return;
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    CGRect frame = self.subPageTitle.frame;
    CGFloat tipHeight = 6.0;
    CGFloat x = (frame.size.width + [self.subPageTitle.text sizeWithAttributes:@{NSFontAttributeName:self.subPageTitle.font}].width) / 2 + tipHeight;
    UIView *icon = [[UIView alloc] initWithFrame:CGRectMake(x, (frame.size.height - tipHeight) / 2, tipHeight, tipHeight)];
    icon.tag = TIP_ICON_TAG;
    icon.backgroundColor = [UIColor redColor];
    icon.layer.cornerRadius = tipHeight / 2;
    [self.subPageTitle.superview addSubview:icon];
  });
}

- (void)hideNewsTipIcon {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[self.subPageTitle.superview viewWithTag:TIP_ICON_TAG] removeFromSuperview];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - WeiboResponseDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  if ([Preferences isLoggin]) {
    _shareViewController = [[ShareMusicViewController alloc] initWithNibName:@"ShareMusicViewController" andImage:_tempWeiboImage andText:_tempWeiboMessage];
    _shareViewController.topMusicController = self;
    [[M2AppDelegate window].rootViewController presentViewController:_shareViewController animated:YES completion:nil];
  }
  [WeiboHelper sharedWeiboHelper].wbDelegate = nil;
}

@end
