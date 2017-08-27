//
//  PushHelper.h
//  ios-newsapp-practice
//
//  Created by dillonzhang on 15/6/23.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHelper : NSObject

+ (PushHelper *)instance;

- (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//注册UserNotification成功的回调
- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
//按钮点击事件回调
- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler;
#endif
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)err;
- (void)didReceiveRemoteNotification:(NSDictionary*)userInfo;

@end
