//
//  WeiboPagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/10.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "WeiboPagerView.h"
#import "WeiboCell.h"
#import "LatestMusicCell.h"

#define WEIBO_CELL_REUSE_TAG @"weibo_cell_nib"

@interface WeiboPagerView() {
  Weibo *_selectedRecord;
}

@property (nonatomic, strong) CustomWebViewController *webViewController;

@end

@implementation WeiboPagerView

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
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  } else {
    [[APIProcessor instance] loadWeiboWithGap:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
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
    [[APIProcessor instance] loadNewsWithCatname:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
      if ([res isMemberOfClass:[NSNull class]]) {
        [self toastNoMoreRecords];
      }
      [self remoteDataLoadComplete];
    } andFailure:^(NSError *error){
      [self remoteDataLoadComplete];
    }];
  } else {
    [[APIProcessor instance] loadWeiboWithGap:self.type andTime:self.lastLoadTime andSuccess:^(NSDictionary *res) {
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
    LatestMusicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:WEIBO_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"LatestMusicCell" bundle:nil] forCellReuseIdentifier:WEIBO_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"LatestMusicCell" owner:self options:nil] objectAtIndex:0];
    }
    News *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithNews:record withType:self.type andIndex:indexPath.row];
    return cell;
    
  } else {
    // Init the cell through reusable cell.
    WeiboCell *cell = [self.tableView dequeueReusableCellWithIdentifier:WEIBO_CELL_REUSE_TAG];
    if (cell == nil) {
      [self.tableView registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:WEIBO_CELL_REUSE_TAG];
      cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] objectAtIndex:0];
    }
    
    Weibo *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configCellWithRecord:record];
    self.lastLoadTime = record.update_time;
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewsType) {
    return ([UIScreen mainScreen].bounds.size.width / 320) * 72.0;
  }
  Weibo *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
  CGSize fontSize = [record.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:WEIBO_CONTENT_FONT_SIZE]}];
  CGFloat height = 236 + (fontSize.height + 5) * (fontSize.width / (self.frame.size.width - 20));
  if (record.thumbnail_pic.length <= 0) {
    height -= 100;
  }
  
  return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewsType) {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  } else {
    Weibo *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([Preferences isLoggin] && record.idstr.length > 0) {
      NSString *url = [[WeiboHelper sharedWeiboHelper] generateWBContentURL:record.idstr];
      [self openUrl:url withTitle:record.screenName];
    } else {
      [[WeiboHelper sharedWeiboHelper] WBAuthorize];
      [WeiboHelper sharedWeiboHelper].wbDelegate = self;
      _selectedRecord = record;
    }
  }
}

- (void)openUrl:(NSString *)url withTitle:(NSString *)title {
    if (!_webViewController) {
    _webViewController = [[CustomWebViewController alloc] initWithNibName:@"CustomWebViewController" bundle:nil andUrl:url andTitle:title andSupport:NO];
    } else {
      [_webViewController loadRequestWithUrl:url andTitle:title];
    }
  [[M2AppDelegate window].rootViewController presentViewController:_webViewController animated:YES completion:nil];
}

#pragma mark - Delegate Methods
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  [WeiboHelper sharedWeiboHelper].wbDelegate = nil;
  if (_selectedRecord) {
    NSString *url = [[WeiboHelper sharedWeiboHelper] generateWBContentURL:_selectedRecord.idstr];
    [self openUrl:url withTitle:_selectedRecord.screenName];
  }
}

#pragma mark - Properties
- (BOOL)defaultAscending {
  if (self.isNewsType) {
    return NO;
  } else {
    return [self.type isEqualToString:GAP_DAY];
  }
}

- (NSString *)defaultEntityName {
  if (self.isNewsType) {
    return @"News";
  } else {
    return @"Weibo";
  }
}

- (NSPredicate *)defaultFetchPredicate {
  if (self.isNewsType) {
    return [NSPredicate predicateWithFormat:@"cat_name = %@", self.type];
  } else {
    return [NSPredicate predicateWithFormat:@"type = %@", self.type];
  }
}

- (NSString *)defaultSortKeyName {
  if (self.isNewsType) {
    return @"title";
  } else {
    if ([self.type isEqualToString:GAP_DAY]) {
      return @"sortWeight";
    } else {
      return @"created_at";
    }
  }
}

- (NSString *)recordLinkPropertyName {
  if (self.isNewsType) {
    return @"detailPageLink";
  } else {
    return nil;
  }
}

- (NSString *)recordLinkTitle {
  if (self.isNewsType) {
    return @"title";
  } else {
    return nil;
  }
}


@end
