//
//  BasePagerView.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
#import "APIProcessor.h"
#import "CustomWebViewController.h"

@interface BasePagerView : UIView<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
  NSFetchedResultsController *__fetchedResultsController;
}

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL isNewsType; // 新增的排行榜数据结构由News构成
@property (nonatomic, strong, getter=getFetchedResultsController) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDate *lastLoadTime; // 记录上次服务器数据更新时间，用于判断是否需要最新数据
@property (nonatomic, strong) NSDate *lastPullTime; // 记录上次服务器手动下拉刷新的时间，用于界面显示
@property (nonatomic, strong) UIView *lastPullTimeLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *spinner;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type;
- (void)loadFirstPageData;
- (void)refreshLatestData;
- (void)loadMoreData;
- (void)remoteDataLoadComplete;
- (NSFetchedResultsController *)getFetchedResultsController;

// 需要重写，用于查询数据库
- (NSString *)defaultEntityName;
- (NSString *)defaultSortKeyName;
- (NSPredicate *)defaultFetchPredicate;
- (BOOL)defaultAscending;
- (NSString *)recordLinkPropertyName;
- (NSString *)recordLinkTitle;

// 打开网页
- (void)openUrl:(NSString *)url withTitle:(NSString *)title andSupport:(BOOL)landscape;
- (void)showSpinner:(BOOL)show withText:(NSString *)text;
- (void)toastMessage:(NSString *)msg;
- (void)toastNoMoreRecords;

@end
