//
//  BasePagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "BasePagerView.h"
#import "NSDate+String.h"

#define PULL_TIME_LABEL_TAG 33

@implementation BasePagerView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type {
  if (self = [super initWithFrame:frame]) {
    self.type = type;
    self.title = title;
    self.isNewsType = ([type isEqualToString:TOPTENSID_WEEK]
                       || [type isEqualToString:NEWS_DRESS]
                       || [type isEqualToString:NEWS_BEAUTIFIER]
                       || [type isEqualToString:NEWS_ENTERTAIN]
                       || [type isEqualToString:NEWS_STARS]
                       || [type isEqualToString:NEWS_FARMS]);
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    //注册下拉刷新功能
    __weak BasePagerView *weakself = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
      [weakself refreshLatestData];
    }];
    
    //注册上拉加载功能
    [self.tableView addInfiniteScrollingWithActionHandler:^{
      [weakself loadMoreData];
    }];
    
    self.tableView.pullToRefreshView.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"下拉刷新...",),
                                               NSLocalizedString(@"松开以更新...",),
                                               NSLocalizedString(@"正在更新...",),
                                               nil];
  }
  
  return self;
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  [self updateLastPullTimeLabel];
}

/*
 在列表底部增加上次更新时间
 */
- (void)updateLastPullTimeLabel {
  self.lastPullTime = [NSDate date];
  UILabel *label = (UILabel *)[self.lastPullTimeLabel viewWithTag:PULL_TIME_LABEL_TAG];
  [label setText:[self.lastPullTime dateIncludeYMDHMAZ]];
}

/*
 自动加载第一页数据
 */
- (void)loadFirstPageData {
  [self showSpinner:YES withText:@"正在加载..."];
  [self.tableView.pullToRefreshView startAnimating];
  // 等待下拉动画结束后开始API调用
  [self performSelector:@selector(refreshLatestData) withObject:nil afterDelay:0.3];
}

// 子类需要重写并实现
- (void)refreshLatestData {}
- (void)loadMoreData {}

/*
 数据下载完成
 */
- (void)remoteDataLoadComplete {
  dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
    if ([self.spinner.labelText isEqualToString:@"正在加载..."]) {
      [self showSpinner:NO withText:nil];
    }
    [self updateLastPullTimeLabel];
  });
  
  self.tableView.pullToRefreshView.titles = [NSMutableArray arrayWithObjects:[[NSDate date] dateChineseStyle],
                                             [[NSDate date] dateChineseStyle],
                                             NSLocalizedString(@"正在更新...",),
                                             nil];
}

#pragma mark - TableView Delegate & Datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

/*
 通过数据库获取将会产生多少行数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

/*
 选择某一行，然后通过WebView呈现具体页面
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *key = [self recordLinkPropertyName];
  if (key.length > 0) {
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *link = [record valueForKey:key];
    NSString *titleProperty = [self recordLinkTitle];
    NSString *title = nil;
    if (titleProperty.length > 0) {
      title = [record valueForKey:titleProperty];
    }
    if (link.length > 0) {
      NAILog(@"WebView", @"Present WebView with Link: %@", link);
      [self openUrl:link withTitle:title andSupport:NO];
    }
  }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  UITableView *tableView = self.tableView;
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      if (!SYSTEM_VERSION_EQUAL_TO(@"8.3") && !SYSTEM_VERSION_EQUAL_TO(@"8.4")) {
        [self .tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:(newIndexPath ? newIndexPath : indexPath)] withRowAnimation:UITableViewRowAnimationNone];
      }
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    default:
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  @try {
    [self.tableView endUpdates];
  }
  @catch (NSException *exception) {
    NAILog(@"ToptenPagerview", @"Error: %@", exception.description);
  }
}

- (NSFetchedResultsController *)getFetchedResultsController {
  if (__fetchedResultsController != nil) {
    return __fetchedResultsController;
  }
  
  if (![self defaultEntityName]) {
    return nil;
  }
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext *moc = [NSManagedObjectContext MR_defaultContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName:[self defaultEntityName] inManagedObjectContext:moc];
  [fetchRequest setEntity:entity];
  
  if ([self defaultSortKeyName]) {
    NSSortDescriptor *updateTime = [[NSSortDescriptor alloc] initWithKey:[self defaultSortKeyName] ascending:[self defaultAscending]];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:updateTime, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
  }
  
  if ([self defaultFetchPredicate]) {
    NSPredicate *predicate = [self defaultFetchPredicate];
    [fetchRequest setPredicate:predicate];
  }
  
  fetchRequest.includesPendingChanges = NO;
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
  
  aFetchedResultsController.fetchRequest.fetchLimit = 0;
  __fetchedResultsController = aFetchedResultsController;
  __fetchedResultsController.delegate = self;
  
  return __fetchedResultsController;
}

#pragma mark - Properties
- (NSString *)defaultEntityName {
  return nil;
}

- (NSPredicate *)defaultFetchPredicate {
  return nil;
}

- (NSString *)defaultSortKeyName {
  return nil;
}

- (BOOL)defaultAscending {
  return !self.isNewsType;
}

- (NSString *)recordLinkPropertyName {
  return nil;
}

- (NSString *)recordLinkTitle {
  return nil;
}

- (UIView *)lastPullTimeLabel {
  if (!_lastPullTimeLabel) {
    _lastPullTimeLabel = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    _lastPullTimeLabel.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.tag = PULL_TIME_LABEL_TAG;
    [_lastPullTimeLabel addSubview:label];
    [self addSubview:_lastPullTimeLabel];
  }
  
  return _lastPullTimeLabel;
}

#pragma mark - Util Methods
- (void)openUrl:(NSString *)url withTitle:(NSString *)title andSupport:(BOOL)landscape {
  CustomWebViewController *webViewController = [[CustomWebViewController alloc] initWithNibName:@"CustomWebViewController" bundle:nil andUrl:url andTitle:title andSupport:landscape];
  [[M2AppDelegate window].rootViewController presentViewController:webViewController animated:YES completion:nil];
}

- (MBProgressHUD *)spinner {
  if (!_spinner) {
    _spinner = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:_spinner];
  }
  
  return _spinner;
}

/*
 显示和隐藏模态进度圈
 */
- (void)showSpinner:(BOOL)show withText:(NSString *)text {
  if (show) {
    [self.spinner setMode:MBProgressHUDModeIndeterminate];
    [self.spinner setLabelText:text];
    [self.spinner show:YES];
  } else {
    [self.spinner hide:NO];
  }
}

/*
 展示toast消息
 */
- (void)toastMessage:(NSString *)msg {
  dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.spinner setMode:MBProgressHUDModeText];
    [self.spinner setLabelText:msg];
    [self.spinner show:YES];
    [self performSelector:@selector(hideToast) withObject:nil afterDelay:0.6];
  });
}

- (void)hideToast {
  [self.spinner hide:YES];
}

- (void)toastNoMoreRecords {
  [self toastMessage:@"当前数据已经是最新的！"];
}

@end
