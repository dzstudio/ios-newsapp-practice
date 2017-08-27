//
//  WeiboHelper.m
//
//  Created by dillonzhang on 15/5/21.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "WeiboHelper.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "WeiboHTTP.h"
#import "M2Preferences.h"
#import "WEiboUser.h"
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"
#import "WBHttpRequest+WeiboToken.h"

@implementation WeiboHelper

static dispatch_once_t oncePredicate;

#pragma mark - Singleton life cycle
+ (WeiboHelper *)sharedWeiboHelper {
  static WeiboHelper *_sharedWeiboHelper;
  dispatch_once(&oncePredicate, ^{
    _sharedWeiboHelper = [[self alloc] init];
    [WeiboSDK registerApp:WEIBO_APPKEY];
    [WeiboSDK enableDebugMode:YES];
  });
  
  return _sharedWeiboHelper;
}

#pragma mark - Public Methods
- (void)WBAuthorize {
  WBAuthorizeRequest *request = [WBAuthorizeRequest request];
  request.redirectURI = WEIBO_REDIRECT_URI;
  request.scope = WEIBO_SCOPE;
  request.userInfo = @{@"SSO_From": @"ViewController",
                       @"Other_Info_1": [NSNumber numberWithInt:123],
                       @"Other_Info_2": @[@"obj1", @"obj2"],
                       @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
  [WeiboSDK sendRequest:request];
}

- (void)logout {
  [WeiboSDK logOutWithToken:Preferences.wbtoken delegate:self withTag:@"user_1"];
}

/*
 微博分享
 */
- (void)sendTextContent:(NSString *)text imageData:(NSData *)imageData {
  WBImageObject *image = [WBImageObject object];
  image.imageData = imageData;
  
  __weak WeiboHelper *weakself = self;
  [WBHttpRequest requestForShareAStatus:text contatinsAPicture:image orPictureUrl:nil withAccessToken:Preferences.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
    if ([weakself.wbDelegate respondsToSelector:@selector(didSendWeiboPost:)]) {
      [weakself.wbDelegate didSendWeiboPost:error];
    }
  }];
}

- (void)getUserInfo:(NSString *)userId {
  [WBHttpRequest requestForUserProfile:userId withAccessToken:Preferences.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
    NAILog(@"Weibo SDK", @"Get User Info, result:%@, error:%@", result, error);
    if (result && [result isMemberOfClass:[WeiboUser class]]) {
      Preferences.wbUsername = ((WeiboUser *)result).screenName;
      [[NSNotificationCenter defaultCenter] postNotificationName:WEIBO_USERNAME_UPDATED object:self];
    }
  }];
}

/*
 获取微博正文的网址
 */
- (NSString *)generateWBContentURL:(NSString *)wid {
  return [NSString stringWithFormat:@"%@?access_token=%@&uid=%@&id=%@", WEIBO_GO_URL, Preferences.wbtoken, Preferences.wbCurrentUserID, wid];
}

/**
 * @description 判断登录是否过期
 * @return YES为已过期；NO为未为期
 */
- (BOOL)isAuthorizeExpired {
    NSDate *now = [NSDate date];
    NSDate *expire = Preferences.wbExpireDate;
    BOOL expired = ([now compare:expire] == NSOrderedDescending);
    return expired;
}

/*
 自动获取续期Token
 */
- (void)autoRenewToken {
  [WBHttpRequest requestForRenewAccessTokenWithRefreshToken:Preferences.wbRefreshtoken queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error){
    if (!error && result) {
      NSDictionary *data = (NSDictionary *)result;
      Preferences.wbtoken = [data objectForKey:@"access_token"];
      Preferences.wbRefreshtoken = [data objectForKey:@"refresh_token"];
      Preferences.wbCurrentUserID = [data objectForKey:@"uid"];
      
      // 更新过期时间
      NSTimeInterval dateInterval = [[NSDate date] timeIntervalSinceNow];
      double expiresIn = ((NSString *)[data objectForKey:@"expires_in"]).doubleValue;
      Preferences.wbExpireDate = [NSDate dateWithTimeIntervalSinceNow:(dateInterval + expiresIn)];
    }
  }];
}

#pragma mark - WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error {}


#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 [WBBaseResponse userInfo] 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
  // 处理用户授权
  if ([response isMemberOfClass:[WBAuthorizeResponse class]]) {
    switch (response.statusCode) {
      case WeiboSDKResponseStatusCodeSuccess:
        //授权成功
        Preferences.wbtoken = ((WBAuthorizeResponse *)response).accessToken;
        Preferences.wbRefreshtoken = ((WBAuthorizeResponse *)response).refreshToken;
        Preferences.wbExpireDate = ((WBAuthorizeResponse *)response).expirationDate;
        Preferences.wbCurrentUserID = ((WBAuthorizeResponse *)response).userID;
        Preferences.wbCurrentUserInfo = ((WBAuthorizeResponse *)response).userInfo;
        [self getUserInfo:Preferences.wbCurrentUserID];
        if ([self.wbDelegate respondsToSelector:@selector(didReceiveWeiboResponse:)]) {
          [self.wbDelegate didReceiveWeiboResponse:response];
        }
        break;
      case WeiboSDKResponseStatusCodeUserCancel:
        //用户取消发送
        break;
      case WeiboSDKResponseStatusCodeSentFail:
        //发送失败
        break;
      case WeiboSDKResponseStatusCodeAuthDeny:
        //授权失败
        break;
      case WeiboSDKResponseStatusCodeUserCancelInstall:
        //用户取消安装微博客户端
        break;
      case WeiboSDKResponseStatusCodeUnsupport:
        //不支持的请求
        break;
        break;
      case WeiboSDKResponseStatusCodeUnknown:
        //未知
        break;
      default:
        break;
    }
  }
}

@end
