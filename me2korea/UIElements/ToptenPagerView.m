//
//  ToptenPagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/30.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "ToptenPagerView.h"
#import "ToptenCell.h"
#import "TaobaoCell.h"
#import "LatestMusicCell.h"
#import "TopMusicViewController.h"

#define TOPTEN_CELL_REUSE_TAG @"topten_cell_nib"

@implementation ToptenPagerView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type {
  if (self = [super initWithFrame:frame]) {
    self.type = type;
    self.title = title;
    self.isNewsType = [type isEqualToString:TOPTENSID_WEEK];
    self.isTaobaoType = [type isEqualToString:TOPTENSID_LATEST];
    
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
  if (self.isNewsType && !self.isTaobaoType) {
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      } else {
        [self showSpinner:NO withText:nil];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
   
  } else if (self.isTaobaoType) {
    [[APIProcessor instance] loadTaobaoWithStore:@"hot_album" andType:@"Latest" andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  
  } else {
    [[APIProcessor instance] loadToptenzWithSite:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      } else {
        [self showSpinner:NO withText:nil];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
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
  if (self.isNewsType && !self.isTaobaoType) {
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  } else if (self.isTaobaoType) {
    [[APIProcessor instance] loadTaobaoWithStore:@"hot_album" andType:@"Latest" andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
    
  } else {
    [[APIProcessor instance] loadToptenzWithSite:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      // 隐藏红点
      [M2AppDelegate.topMusicViewController hideNewsTipIcon];
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
    LatestMusicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TOPTEN_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"LatestMusicCell" bundle:nil] forCellReuseIdentifier:TOPTEN_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"LatestMusicCell" owner:self options:nil] objectAtIndex:0];
    }
    News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithNews:record withType:self.type andIndex:indexPath.row];
    return cell;
    
  } else if (self.isTaobaoType) {
    // Init the cell through reusable cell.
    TaobaoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TOPTEN_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"TaobaoCell" bundle:nil] forCellReuseIdentifier:TOPTEN_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"TaobaoCell" owner:self options:nil] objectAtIndex:0];
    }
    
    Taobao *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithRecord:record withType:self.type];
    self.lastLoadTime = record.update_time;
    
    return cell;
    
  } else {
    // Init the cell through reusable cell.
    ToptenCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TOPTEN_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"ToptenCell" bundle:nil] forCellReuseIdentifier:TOPTEN_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"ToptenCell" owner:self options:nil] objectAtIndex:0];
    }
    Toptenz *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithRecord:record withType:self.type];
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewsType) {
    News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (record) {
      self.lastLoadTime = [NSDate date];
    }
    return ([UIScreen mainScreen].bounds.size.width / 320) * 72.0;
  } else if (self.isTaobaoType) {
    return 98;
  } else {
    Toptenz *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (record) {
      self.lastLoadTime = record.update_time;
    }
    return ([UIScreen mainScreen].bounds.size.width / 320) * 43.0;
  }
}

#pragma mark - Properties
- (NSString *)defaultEntityName {
  if (self.isNewsType) {
    return @"News";
  } else if (self.isTaobaoType) {
    return @"Taobao";
  } else {
    return @"Toptenz";
  }
}

- (NSPredicate *)defaultFetchPredicate {
  if (self.isNewsType) {
    return [NSPredicate predicateWithFormat:@"cat_name = %@", self.type];
  } else if (self.isTaobaoType) {
    return [NSPredicate predicateWithFormat:@"type = %@ AND store = %@", @"Latest", @"hot_album"];
  } else {
    NSNumber *sid = [NSDecimalNumber decimalNumberWithString:[Constants.siteIdMap objectForKey:self.type]];
    return [NSPredicate predicateWithFormat:@"sid = %@", sid];
  }
}

- (NSString *)defaultSortKeyName {
  if (self.isNewsType) {
    return @"createTime";
  } else if (self.isTaobaoType) {
    return @"name";
  } else {
    return @"rank";
  }
}

- (NSString *)recordLinkPropertyName {
  if (self.isNewsType) {
    return @"detailPageLink";
  } else if (self.isTaobaoType) {
    return @"link";
  } else {
    return @"extern_link";
  }
}

- (NSString *)recordLinkTitle {
  if ([self.type isEqualToString:@"hanteo_day"] || [self.type isEqualToString:@"hanteo_real"]) {
    return @"album";
  } else if (self.isTaobaoType) {
    return @"name";
  } else {
    return @"title";
  }
}

@end
