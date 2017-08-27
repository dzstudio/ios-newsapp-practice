//
//  MarketViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketPagerView.h"
#import "CustomNavigationBar.h"

#define STORE_NAME_HANLIU @"韩国"
#define STORE_NAME_ZHOUBIAN @"韩流生活"

@interface MarketViewController () {
  NSInteger currentPageIndex;
}

@property (nonatomic, copy) NSString *store;
@property (nonatomic, strong) NSArray *pageConfig;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet TabBarControl *tabBarControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;

@end

@implementation MarketViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _pageConfig = @[@{@"title": @"人气", @"action": TAOTYPE_FAV},
                    @{@"title": @"新品", @"action": TAOTYPE_LATEST},
                    @{@"title": @"推荐", @"action": TAOTYPE_SUGGEST},
                    @{@"title": @"时尚服饰", @"action": NEWS_DRESS},
                    @{@"title": @"美容美妆", @"action": NEWS_BEAUTIFIER}];
    self.store = TAOSTORE_HANLIU;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationBar setTitle:STORE_NAME_HANLIU];
  self.navigationBar.btnSwitch.hidden = NO;
  [self.navigationBar.btnSwitch addTarget:self action:@selector(onTapSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
  [self.navigationBar.btnMenu addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // 初始化榜单页面
  if (!_pages) {
    CGFloat offsetLeft = 0;
    currentPageIndex = -1; // 初始化页面
    _pages = [NSMutableArray array];
    
    NSMutableArray *tabTitles = [NSMutableArray array];
    for (NSDictionary *page in self.pageConfig) {
      CGRect pageFrame = (CGRect){offsetLeft, 0, self.pagerScrollView.frame.size};
      offsetLeft += self.view.frame.size.width;
      MarketPagerView *pagerView = [[MarketPagerView alloc] initWithFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"action"]];
      pagerView.store = self.store;
      
      [self.pages addObject:pagerView];
      [self.pagerScrollView addSubview:pagerView];
      [self.pagerScrollView setContentSize:CGSizeMake(offsetLeft, self.pagerScrollView.frame.size.height)];
      [tabTitles addObject:[page objectForKey:@"title"]];
    }
    
    [self configCurrentPage];
    [self.tabBarControl setupWithTitles:tabTitles andDelegate:self];
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
  MarketPagerView *pageView = [self.pages objectAtIndex:index];
  [self.tabBarControl setSelectedTabWith:currentPageIndex];
  
  if ([pageView.tableView numberOfRowsInSection:0] <= 0 || [Constants.autoRefreshPagers containsObject:NSStringFromClass(pageView.class)]) {
    // 第一次初始化时，本地没有数据，需要加载一次
    [pageView loadFirstPageData];
  }
}

#pragma mark - Delegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self performSelector:@selector(configCurrentPage) withObject:nil afterDelay:0.3];
}

- (void)onTabItemIndex:(NSInteger)index {
  CGFloat offset = (index - currentPageIndex) * self.pagerScrollView.frame.size.width;
  UIView *page = [self.pages objectAtIndex:currentPageIndex];
  CGRect frame = page.frame;
  frame.origin.x += offset;
  [self.pagerScrollView scrollRectToVisible:frame animated:YES];
  [self performSelector:@selector(configCurrentPage) withObject:nil afterDelay:0.3];
}

#pragma mark - User Events
- (void)onTapSwitchBtn:(id) sender {
  self.store = [self.store isEqualToString:TAOSTORE_HANLIU] ? TAOSTORE_ZHOUBIAN : TAOSTORE_HANLIU;
  [self.navigationBar setTitle:([self.store isEqualToString:TAOSTORE_HANLIU] ? STORE_NAME_HANLIU : STORE_NAME_ZHOUBIAN)];
  for (MarketPagerView *page in _pages) {
    page.store = self.store;
    currentPageIndex = -1;
    [self configCurrentPage];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
