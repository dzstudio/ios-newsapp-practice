//
//  M2Preferences.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/17.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "M2Preferences.h"

@implementation M2Preferences

- (BOOL)isLoggin {
  return self.wbtoken.length > 0;
}

- (void)logout {
  [[WeiboHelper sharedWeiboHelper] logout];
  self.wbtoken = nil;
  self.wbRefreshtoken = nil;
  self.wbExpireDate = nil;
  self.wbCurrentUserInfo = nil;
  self.wbCurrentUserID = nil;
}

@end
