//
//  NewsViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NewsViewController.h"
#import "WeiboPagerView.h"
#import "CustomNavigationBar.h"

@interface NewsViewController () {
  NSInteger currentPageIndex;
}

@property (nonatomic, copy) NSString *store;
@property (nonatomic, strong) NSArray *pageConfig;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet TabBarControl *tabBarControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;

@end

@implementation NewsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _pageConfig = @[@{@"title": @"实时新闻", @"action": GAP_HOUR},
                    @{@"title": @"当日热点", @"action": GAP_DAY},
                    @{@"title": @"花絮八卦", @"action": NEWS_ENTERTAIN},
                    @{@"title": @"明星专访", @"action": NEWS_STARS},
                    @{@"title": @"动物农场", @"action": NEWS_FARMS}];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationBar setTitle:@"新闻资讯"];
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
      WeiboPagerView *pagerView = [[WeiboPagerView alloc] initWithFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"action"]];
      
      [self.pages addObject:pagerView];
      [self.pagerScrollView addSubview:pagerView];
      [self.pagerScrollView setContentSize:CGSizeMake(offsetLeft, self.pagerScrollView.frame.size.height)];
      [tabTitles addObject:[page objectForKey:@"title"]];
    }
    
    [self configCurrentPage];
    [self.tabBarControl setupWithTitles:tabTitles andDelegate:self];
  } else {
    WeiboPagerView *pageView = [self.pages objectAtIndex:currentPageIndex];
    [pageView.tableView reloadData];
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
  WeiboPagerView *pageView = [self.pages objectAtIndex:index];
  [self.tabBarControl setSelectedTabWith:currentPageIndex];
  
  if ([pageView.tableView numberOfRowsInSection:0] <= 0 || [Constants.autoRefreshPagers containsObject:NSStringFromClass(pageView.class)]) {
    // 第一次初始化时，本地没有数据，需要加载一次
    [pageView loadFirstPageData];
  }
    
  [AnalyticsHelper event:@"newsTab" label:[self.pageConfig[currentPageIndex]objectForKey:@"action"]];
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
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
