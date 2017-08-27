//
//  WeiboHelper.h
//
//  Created by dillonzhang on 15/5/21.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#define WEIBO_USERNAME_UPDATED @"weibo_username_updated"

@protocol WeiboResponseDelegate <NSObject>

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;
@optional
- (void)didSendWeiboPost:(id)result;

@end

@interface WeiboHelper : NSObject<WeiboSDKDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) id<WeiboResponseDelegate> wbDelegate;

+ (WeiboHelper *)sharedWeiboHelper;

- (void)WBAuthorize;
- (void)logout;
- (void)sendTextContent:(NSString *)text imageData:(NSData *)imageData;
- (NSString *)generateWBContentURL:(NSString *)wid;
- (BOOL)isAuthorizeExpired;
- (void)autoRenewToken;

@end
