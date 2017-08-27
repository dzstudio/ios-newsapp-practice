//
//  LiveViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/9.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import "LiveViewController.h"
#import "LivePagerView.h"
#import "NovelPagerView.h"
#import "CustomNavigationBar.h"

@interface LiveViewController () {
  NSInteger currentPageIndex;
}

@property (nonatomic, strong) NSArray *pageConfig;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet TabBarControl *tabBarControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet NovelPagerView *novelPagerView;

@end

@implementation LiveViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _pageConfig = @[@{@"title": @"美食", @"action": @"美食"},
                    @{@"title": @"旅游", @"action": @"旅游"},
                    @{@"title": @"留学", @"action": @"留学"},
                    @{@"title": @"瘦身", @"action": @"瘦身"},
                    @{@"title": @"剧本小说", @"action": @"剧本小说"}];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationBar setTitle:@"韩流生活"];
  [self.navigationBar.btnMenu addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // 初始化韩流生活子页面
  if (!_pages) {
    CGFloat offsetLeft = 0;
    currentPageIndex = -1; // 初始化页面
    _pages = [NSMutableArray array];
    
    NSMutableArray *tabTitles = [NSMutableArray array];
    for (NSDictionary *page in self.pageConfig) {
      LivePagerView *pagerView = nil;
      CGRect pageFrame = (CGRect){offsetLeft, 0, self.pagerScrollView.frame.size};
      offsetLeft += self.view.frame.size.width;
      if (![[page objectForKey:@"title"] isEqualToString:@"剧本小说"]) {
        pagerView = [[LivePagerView alloc] initWithFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"action"]];
      } else {
        pagerView = self.novelPagerView;
        [self.novelPagerView initPageFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"action"]];
      }
      
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
  LivePagerView *pageView = [self.pages objectAtIndex:index];
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

#pragma mark - Properties
- (NovelPagerView *)novelPagerView {
  if (!_novelPagerView) {
    [[NSBundle mainBundle] loadNibNamed:@"NovelPagerView" owner:self options:nil];
  }
  
  return _novelPagerView;
}

@end
