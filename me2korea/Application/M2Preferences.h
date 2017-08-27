//
//  M2Preferences.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/17.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M2Preferences : NSObject

// 应用配置信息
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appBuild;
@property (nonatomic, strong) NSNumber *hideVideos;
@property (nonatomic, strong) NSNumber *checkUpdate;

// 用户微博信息
@property (nonatomic, strong) NSString *wbtoken;
@property (nonatomic, strong) NSString *wbRefreshtoken;
@property (nonatomic, strong) NSDate *wbExpireDate;
@property (nonatomic, strong) NSString *wbCurrentUserID;
@property (nonatomic, strong) NSDictionary *wbCurrentUserInfo;
@property (nonatomic, strong) NSString *wbUsername;

- (BOOL)isLoggin;
- (void)logout;

@end
