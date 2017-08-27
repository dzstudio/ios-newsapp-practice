//
//  AppDelegate.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/22.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define TABBAR_HEIGHT 63

@class TopMusicViewController;
@class NewsViewController;
@class MarketViewController;
@class MediaViewController;
@class AboutUsViewController;
@class LiveViewController;
@class M2Preferences;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) M2Preferences *preferences;

// 主要的UIViewController
@property (nonatomic, strong) TopMusicViewController *topMusicViewController; // 音乐排行榜
@property (nonatomic, strong) NewsViewController *newsViewController;         // 新闻资讯
@property (nonatomic, strong) MarketViewController *marketViewController;     // DZ商城
@property (nonatomic, strong) MediaViewController *mediaViewController;       // 韩剧综艺
@property (nonatomic, strong) AboutUsViewController *aboutUsViewController;   // 关于我们
@property (nonatomic, strong) LiveViewController *liveViewController;   // 韩流生活

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)managedObjectContext;


@end

