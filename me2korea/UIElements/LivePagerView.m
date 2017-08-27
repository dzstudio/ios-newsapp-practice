//
//  LivePagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/9.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import "LivePagerView.h"
#import "LatestMusicCell.h"


#define LIVE_CELL_REUSE_TAG @"live_cell_nib"

@implementation LivePagerView

#pragma mark - 加载远程数据
/*
 下拉刷新
 */
- (void)refreshLatestData {
  if (self.tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
    return;
  }
  
  if ([self.tableView numberOfRowsInSection:0] <= 0) {
    self.lastLoadTime = nil;
  }
  
  [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
    if ([res isMemberOfClass:[NSNull class]]) {
      [self toastNoMoreRecords];
    }
    [self remoteDataLoadComplete];
  } andFailure:^(NSError *error){
    [self remoteDataLoadComplete];
  }];
}

/*
 加载更多
 */
- (void)loadMoreData {
  if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
    return;
  }
  [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
    if ([res isMemberOfClass:[NSNull class]]) {
      [self toastNoMoreRecords];
    }
    [self remoteDataLoadComplete];
  } andFailure:^(NSError *error){
    [self remoteDataLoadComplete];
  }];
}

#pragma mark - TableView Delegate Methods
/*
 生成列表中的每一行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Init the cell through reusable cell.
  LatestMusicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LIVE_CELL_REUSE_TAG];
  if (cell == nil) {
    [self.tableView registerNib:[UINib nibWithNibName:@"LatestMusicCell" bundle:nil] forCellReuseIdentifier:LIVE_CELL_REUSE_TAG];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"LatestMusicCell" owner:self options:nil] objectAtIndex:0];
  }
  News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell configCellWithNews:record withType:self.type andIndex:indexPath.row];
  return cell;
}

/*
 自定义行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewsType) {
    News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (record) {
      self.lastLoadTime = [NSDate date];
    }
    return ([UIScreen mainScreen].bounds.size.width / 320) * 72.0;
  } else {
    return 120;
  }
}

#pragma mark - Properties
- (NSString *)defaultEntityName {
  return @"News";
}

- (NSPredicate *)defaultFetchPredicate {
  return [NSPredicate predicateWithFormat:@"cat_name = %@", self.type];
}

- (NSString *)defaultSortKeyName {
  return @"createTime";
}

- (NSString *)recordLinkPropertyName {
  return @"detailPageLink";
}

- (NSString *)recordLinkTitle {
  return @"title";
}

@end
