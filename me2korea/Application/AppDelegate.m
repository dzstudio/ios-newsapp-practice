//
//  AppDelegate.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/22.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "TopMusicViewController.h"
#import "NewsViewController.h"
#import "MarketViewController.h"
#import "MediaViewController.h"
#import "AboutUsViewController.h"
#import "LiveViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "NSObject+PropertyPersistance.h"
#import "NSObject+PropertiesAsDictionary.h"
#import "CheckNetwork.h"
#import "PushHelper.h"

@interface AppDelegate ()

@property (nonatomic, strong) RDVTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  // 初始化导航栏控制器, 底部的tabBar
  self.tabBarController = [[RDVTabBarController alloc] init];
  
  // 设置MagicalRecord的数据库连接
  [MagicalRecord setupCoreDataStackWithStoreNamed:@"ios-newsapp-practice.sqlite"];
  self.window.backgroundColor = [UIColor whiteColor];
  
  //检查网络是否存在 如果不存在 则弹出提示
  [Utils instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
  
  // 设置Preferences初始值
  if (!Preferences.hideVideos) {
    Preferences.hideVideos  = [NSNumber numberWithBool:YES];
  }
  if (!Preferences.checkUpdate) {
    Preferences.checkUpdate  = [NSNumber numberWithBool:NO];
  }
  NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  
  // 调用API判断是否需要隐藏内容, 如果API调用过并且返回true则不再继续调用
  //if (Preferences.hideVideos.boolValue || !Preferences.checkUpdate.boolValue || ![Preferences.appVersion isEqualToString:appVersion]) {
  if (Preferences.hideVideos.boolValue || ![Preferences.appVersion isEqualToString:appVersion]) {
      
    [[APIProcessor instance] videoConfigSuccess:^(id res){
      if (res) {
        NSArray *items = (NSArray *)res;
        NSString *hasVideo, *marketVersion;
          
        for (NSInteger i = 0; i < items.count ; i++) {
          NSDictionary *dict = [items objectAtIndex:i];
          if ([(NSString *)[dict objectForKey:@"name"] isEqualToString:@"video"]) {
              hasVideo = [dict objectForKey:@"value"];
          }
          if ([(NSString *)[dict objectForKey:@"name"] isEqualToString:@"version"]) {
              marketVersion = [dict objectForKey:@"value"];
          }
        }
          
        NSComparisonResult cmp = [appVersion caseInsensitiveCompare:marketVersion];
        if(cmp <= NSOrderedSame) {
            if ([hasVideo isEqualToString:@"1"]) {
                Preferences.hideVideos = [NSNumber numberWithBool:NO];
                Preferences.checkUpdate = [NSNumber numberWithBool:YES];
                Preferences.appVersion = appVersion;
                Preferences.appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            } else {
                Preferences.hideVideos = [NSNumber numberWithBool:YES];
            }
        }
          
        if (Preferences.hideVideos.boolValue) {
          [self showNormalControllers];
        } else {
          [self showAllControllers];
        }
      } else {
        Preferences.hideVideos = [NSNumber numberWithBool:YES];
        [self showNormalControllers];
      }
    } andFailure:^(NSError *error) {
      Preferences.hideVideos = [NSNumber numberWithBool:YES];
      [self showNormalControllers];
    }];
  } else {
    [self showAllControllers];
  }
  
#ifdef DEBUG
  [[Logger instance] setLogLevel:NLLInfo];
#else
  [[Logger instance] setLogLevel:NLLError];
#endif
    
  [AnalyticsHelper start];
    
  [[PushHelper instance] didFinishLaunchingWithOptions:launchOptions];
   
  return YES;
}

- (void)showAllControllers {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tabBarController setViewControllers:@[self.topMusicViewController, self.newsViewController, self.liveViewController, self.marketViewController, self.mediaViewController]];
    self.window.rootViewController = self.tabBarController;
    
    // 定制导航栏的样式
    [self setupTabBarStyle:self.tabBarController];
    [self.window makeKeyAndVisible];
  });
}

- (void)showNormalControllers {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tabBarController setViewControllers:@[self.topMusicViewController, self.newsViewController ,
                                           self.marketViewController]];
    self.window.rootViewController = self.tabBarController;
    
    // 定制导航栏的样式
    [self setupTabBarStyle:self.tabBarController];
    [self.window makeKeyAndVisible];
  });
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Saves changes in the application's managed object context before the application terminates.
  [[NSManagedObjectContext MR_context] MR_saveToPersistentStoreAndWait];
  [MagicalRecord cleanUp];
}

#pragma mark - Push related Method

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[PushHelper instance] didReceiveLocalNotification:notification];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[PushHelper instance] didRegisterUserNotificationSettings:notificationSettings];
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    [[PushHelper instance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[PushHelper instance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    [[PushHelper instance] didFailToRegisterForRemoteNotificationsWithError:err];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [[PushHelper instance] didReceiveRemoteNotification:userInfo];
}

#pragma mark - Util Method
/*
 定制导航栏样式
 */
- (void)setupTabBarStyle:(RDVTabBarController *)tabBarController {
  RDVTabBar *tabBar = tabBarController.tabBar;
  [tabBar setFrame:CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), TABBAR_HEIGHT)];
  
  // 底部栏图标列表
  NSArray *icons;
  if (Preferences.hideVideos.boolValue) {
    icons = @[@"tabbar_music", @"tabbar_news", @"tabbar_mall"];
  } else {
    icons = @[@"tabbar_music", @"tabbar_news", @"tabbar_life", @"tabbar_mall", @"tabbar_variety"];
  }
  NSInteger i = 0;
  for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
    [item setBackgroundColor:[UIColor colorWithHexString:@"#2B3D59"]];
    [item setTitlePositionAdjustment:UIOffsetMake(0, 15)];
    [item setSelectedTitleAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#72DCD6"],NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
    [item setUnselectedTitleAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#AACACC"],NSFontAttributeName:[UIFont systemFontOfSize:11.0]}];
    NSString *imageName = [icons objectAtIndex:i];
    NSString *selectedImage = [NSString stringWithFormat:@"%@_selected", imageName];
    [item setFinishedSelectedImage:[UIImage imageNamed:selectedImage] withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
    [item setImagePositionAdjustment:UIOffsetMake(0, -3)];
    [item setTitlePositionAdjustment:UIOffsetMake(0, 2)];
    i++;
  }
}

#pragma mark - Properties
- (TopMusicViewController *)topMusicViewController {
  if (!_topMusicViewController) {
    _topMusicViewController = [[TopMusicViewController alloc] initWithNibName:@"TopMusicViewController" bundle:nil];
    _topMusicViewController.title = @"音乐排行榜";
  }
  
  return _topMusicViewController;
}

- (NewsViewController *)newsViewController {
  if (!_newsViewController) {
    _newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    _newsViewController.title = @"新闻资讯";
  }
  
  return _newsViewController;
}

- (MarketViewController *)marketViewController {
  if (!_marketViewController) {
    _marketViewController = [[MarketViewController alloc] initWithNibName:@"MarketViewController" bundle:nil];
    _marketViewController.title = @"DZ商城";
  }
  
  return _marketViewController;
}

- (MediaViewController *)mediaViewController {
  if (!_mediaViewController) {
    _mediaViewController = [[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
    _mediaViewController.title = @"韩剧综艺";
  }
  
  return _mediaViewController;
}

- (AboutUsViewController *)aboutUsViewController {
  if (!_aboutUsViewController) {
    _aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    _aboutUsViewController.title = @"关于DZ";
  }
  
  return _aboutUsViewController;
}

- (LiveViewController *)liveViewController {
  if (!_liveViewController) {
    _liveViewController = [[LiveViewController alloc] initWithNibName:@"LiveViewController" bundle:nil];
    _liveViewController.title = @"韩流生活";
  }
  
  return _liveViewController;
}

- (M2Preferences *)preferences {
  if (!_preferences) {
    _preferences = [[M2Preferences alloc] init];
    [_preferences setPersistanceOn:nil];
  }
  
  return _preferences;
}

#pragma mark - Check Network
- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [Utils instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
  if ([Utils instance].isNetworkRunning == NO) {
    UIAlertView *myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"未连接网络,将使用离线模式" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
    [myalert show];
  }
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ios-newsapp-practice" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ios-newsapp-practice.sqlite"];
  NSError *error = nil;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NAELog(@"Coredata", @"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NAELog(@"Coredata", @"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [WeiboSDK handleOpenURL:url delegate:[WeiboHelper sharedWeiboHelper]];
}

@end
