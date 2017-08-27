//
//  MediaViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MediaViewController.h"
#import "CustomNavigationBar.h"
#import "MediaPagerView.h"

@interface MediaViewController () {
  NSInteger currentPageIndex;
}

@property (nonatomic, copy) NSString *store;
@property (nonatomic, strong) NSArray *pageConfig;
@property (nonatomic, strong) NSMutableArray *pages;
@property (weak, nonatomic) IBOutlet TabBarControl *tabBarControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;

@end

@implementation MediaViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    _pageConfig = @[@{@"title": @"热播韩剧", @"type": MEDIATYPE_TV, @"is_end": @"no"},
                    @{@"title": @"已完结韩剧", @"type": MEDIATYPE_TV, @"is_end": @"yes"},
                    @{@"title": @"综艺节目", @"type": MEDIATYPE_ENTERTAINMENT, @"is_end": @"no"},
                    @{@"title": @"韩语学习", @"type": VIDEOTYPE_TUDOU, @"is_end": @"no"}];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationBar setTitle:@"韩剧综艺"];
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
      MediaPagerView *pagerView = [[MediaPagerView alloc] initWithFrame:pageFrame andTitle:[page objectForKey:@"title"] andType:[page objectForKey:@"type"] andEnd:[page objectForKey:@"is_end"]];
      
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
  MediaPagerView *pageView = [self.pages objectAtIndex:index];
  [self.tabBarControl setSelectedTabWith:currentPageIndex];
  
  NSInteger rows = 0;
  if (pageView.tableView) {
    rows = [pageView.tableView numberOfRowsInSection:0];
  } else {
    rows = [pageView.collectionView numberOfItemsInSection:0];
  }
  if (rows <= 0 || [Constants.autoRefreshPagers containsObject:NSStringFromClass(pageView.class)]) {
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
