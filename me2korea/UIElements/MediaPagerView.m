//
//  MediaPagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MediaPagerView.h"
#import "VideoCell.h"
#import "MediaCell.h"
#import "TVDetailViewController.h"
#import "NSDate+String.h"

#define MEDIA_CELL_REUSE_TAG @"media_cell_nib"

@interface MediaPagerView()

@property (nonatomic, strong) UIScrollView *defaultView;

@end

@implementation MediaPagerView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type andEnd:(NSString *)isend {
  if (self = [super initWithFrame:frame]) {
    self.type = type;
    self.title = title;
    self.isEnd = isend;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    if ([self.tableView numberOfRowsInSection:0] <= 0) {
      self.lastLoadTime = nil;
    }
    if ([self.type isEqualToString:VIDEOTYPE_TUDOU]) {
      self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20) style:UITableViewStylePlain];
      self.tableView.delegate = self;
      self.tableView.dataSource = self;
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      [self addSubview:self.tableView];
      self.defaultView = self.tableView;
      
      // 使用CollectionView实现网格显示
    } else {
      self.collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0, 0, frame.size} collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
      self.collectionView.dataSource = self;
      self.collectionView.delegate = self;
      self.collectionView.backgroundColor = [UIColor clearColor];
      [self addSubview:self.collectionView];
      self.defaultView = self.collectionView;
      [self.collectionView registerNib:[UINib nibWithNibName:@"MediaCell" bundle:nil] forCellWithReuseIdentifier:MEDIA_CELL_REUSE_TAG];
    }
    
    //注册下拉刷新功能
    __weak BasePagerView *weakself = self;
    [self.defaultView addPullToRefreshWithActionHandler:^{
      [weakself refreshLatestData];
    }];
    
    //注册上拉加载功能
    [self.defaultView addInfiniteScrollingWithActionHandler:^{
      [weakself loadMoreData];
    }];
    
    self.collectionView.pullToRefreshView.titles
    = self.tableView.pullToRefreshView.titles
    = [NSMutableArray arrayWithObjects:NSLocalizedString(@"下拉刷新...",),
                                               NSLocalizedString(@"松开以更新...",),
                                               NSLocalizedString(@"正在更新...",),
                                               nil];
  }
  
  return self;
}

#pragma mark - 加载远程数据
/*
 下拉刷新
 */
- (void)refreshLatestData {
  if (self.defaultView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
    return;
  }
  
  // 韩剧综艺和视频学习节目分两种API和数据结构
  if ([self.type isEqualToString:VIDEOTYPE_TUDOU]) {
    [[APIProcessor instance] loadVideoWithType:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
    
  } else {
    [[APIProcessor instance] loadMediaWithType:self.type andEnd:[self.isEnd isEqualToString:@"yes"] andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        if ([self.spinner.labelText isEqualToString:@"正在加载..."]) {
          [self showSpinner:NO withText:nil];
        }
      });
    } andFailure:^(NSError *error){
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.pullToRefreshView stopAnimating];
        [self.collectionView reloadData];
        [self showSpinner:NO withText:nil];
      });
    }];
  }
}

/*
 加载更多
 */
- (void)loadMoreData {
  if (self.defaultView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
    return;
  }

  // 韩剧综艺和视频学习节目分两种API和数据结构
  if ([self.type isEqualToString:VIDEOTYPE_TUDOU]) {
    [[APIProcessor instance] loadVideoWithType:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
      });
    } andFailure:^(NSError *error){
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
      });
    }];
    
  } else {
    [[APIProcessor instance] loadMediaWithType:self.type andEnd:[self.isEnd isEqualToString:@"yes"] andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
      });
    } andFailure:^(NSError *error){
      dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.defaultView.infiniteScrollingView stopAnimating];
        [self.collectionView reloadData];
      });
    }];
  }
}

- (void)remoteDataLoadComplete {
  [super remoteDataLoadComplete];
  if (self.collectionView) {
    self.collectionView.pullToRefreshView.titles = [NSMutableArray arrayWithObjects:[[NSDate date] dateChineseStyle],
                                                    [[NSDate date] dateChineseStyle],
                                                    NSLocalizedString(@"正在更新...",),
                                                    nil];
  }
}

#pragma mark - TableView Delegate Methods
/*
 生成列表中的每一行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Init the cell through reusable cell.
  VideoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MEDIA_CELL_REUSE_TAG];
  if (cell == nil) {
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellReuseIdentifier:MEDIA_CELL_REUSE_TAG];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil] objectAtIndex:0];
  }
  
  Video *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell configCellWithRecord:record];
  self.lastLoadTime = record.update_time;
  
  return cell;
}

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
      [self openUrl:link withTitle:title andSupport:YES];
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

#pragma mark - CollectionView Delegate Methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MediaCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:MEDIA_CELL_REUSE_TAG forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"MediaCell" owner:self options:nil] objectAtIndex:0];
  }
  
  Teleplay *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell configCellWithRecord:record];
  self.lastLoadTime = record.update_time;
  
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  
  return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return [[self.fetchedResultsController sections] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = floorf(self.frame.size.width / 3);
  return CGSizeMake(width, floorf(width * 1.6));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  Teleplay *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
  TVDetailViewController *detailViewController = [[TVDetailViewController alloc] initWithNibName:@"TVDetailViewController" bundle:nil andRecord:record];
  [[M2AppDelegate window].rootViewController presentViewController:detailViewController animated:YES completion:nil];
}

#pragma mark - Properties
- (NSString *)defaultEntityName {
  if ([self.type isEqualToString:VIDEOTYPE_TUDOU]) {
    return @"Video";
  } else {
    return @"Teleplay";
  }
}

- (NSPredicate *)defaultFetchPredicate {
  if ([self.type isEqualToString:VIDEOTYPE_TUDOU]) {
    return nil;
  } else {
    return [NSPredicate predicateWithFormat:@"type = %@ AND is_end = %@", self.type, self.isEnd];
  }
}

- (NSString *)defaultSortKeyName {
  return @"sortWeight";
}

- (NSString *)recordLinkPropertyName {
  return @"link";
}

- (NSString *)recordLinkTitle {
  return @"title";
}

@end
