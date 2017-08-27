//
//  MarketPagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MarketPagerView.h"
#import "TaobaoCell.h"
#import "LatestMusicCell.h"

#define TAOOBAO_CELL_REUSE_TAG @"taobao_cell_nib"

@implementation MarketPagerView

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
  if (self.isNewsType) {
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  } else {
    [[APIProcessor instance] loadTaobaoWithStore:self.store andType:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  }
}

/*
 加载更多
 */
- (void)loadMoreData {
  if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
    return;
  }
  if (self.isNewsType) {
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  } else {
    [[APIProcessor instance] loadTaobaoWithStore:self.store andType:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  }
}

#pragma mark - TableView Delegate Methods
/*
 生成列表中的每一行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewsType) {
    // Init the cell through reusable cell.
    LatestMusicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TAOOBAO_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"LatestMusicCell" bundle:nil] forCellReuseIdentifier:TAOOBAO_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"LatestMusicCell" owner:self options:nil] objectAtIndex:0];
    }
    News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithNews:record withType:self.type andIndex:indexPath.row];
    return cell;
    
  } else {
    // Init the cell through reusable cell.
    TaobaoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TAOOBAO_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"TaobaoCell" bundle:nil] forCellReuseIdentifier:TAOOBAO_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"TaobaoCell" owner:self options:nil] objectAtIndex:0];
    }
    
    Taobao *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithRecord:record withType:self.type];
    self.lastLoadTime = record.update_time;
    
    return cell;
  }
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
- (void)setStore:(NSString *)store {
  _store = store;
  self.fetchedResultsController.fetchRequest.predicate = self.defaultFetchPredicate;
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  [self.tableView reloadData];
}

- (BOOL)defaultAscending {
  return NO;
}

- (NSString *)defaultEntityName {
  if (self.isNewsType) {
    return @"News";
  } else {
    return @"Taobao";
  }
}

- (NSPredicate *)defaultFetchPredicate {
  if (self.isNewsType) {
    return [NSPredicate predicateWithFormat:@"cat_name = %@", self.type];
  } else {
    return [NSPredicate predicateWithFormat:@"type = %@ AND store = %@", self.type, self.store];
  }
}

- (NSString *)defaultSortKeyName {
  if (self.isNewsType) {
    return @"createTime";
  } else {
    if ([self.type isEqualToString:TAOTYPE_LATEST]) {
      return @"link";
    } else if ([self.type isEqualToString:TAOTYPE_FAV]) {
      return @"saleCount";
    } else {
      return @"saleCount";
    }
  }
}

- (NSString *)recordLinkPropertyName {
  if (self.isNewsType) {
    return @"detailPageLink";
  } else {
    return @"link";
  }
}

- (NSString *)recordLinkTitle {
  if (self.isNewsType) {
    return @"title";
  } else {
    return @"name";
  }
}

@end
