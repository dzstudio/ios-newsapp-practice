//
//  RestAPIHelper.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/24.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "RestAPIHelper.h"
#import "RDVTabBarController.h"

// API服务器的地址，放在m文件中编译后可提高安全性
#define STAGE_URL      @"http://121.40.73.230/testServle"

@interface RestAPIHelper()

@property (nonatomic, strong) AFHTTPRequestOperationManager *networkOperation;

@end

@implementation RestAPIHelper

/*
 初始化AFNetworking的API连接管理对象
 */
- (instancetype)init {
  if (self = [super init]) {
    _networkOperation = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:STAGE_URL]];
  }
  
  return self;
}

/*
 异步GET API请求
 */
- (void)asyncGetWithParams:(NSDictionary *)params andSuccess:(void (^)(id res))success andFailure:(void (^)(NSError *error))failure {
  [self.networkOperation.operationQueue cancelAllOperations];
  [self showNetworkActivityIndicator];
  
  self.networkOperation.requestSerializer.timeoutInterval = 4;
  [self.networkOperation GET:@"api" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      if (success) {
        success(responseObject);
      }
      [self hideNetworkActivityIndicator];
      self.networkOperation.requestSerializer.timeoutInterval = 30;
    });
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      if (failure) {
        failure(error);
      }
      // 网络错误
      self.networkOperation.requestSerializer.timeoutInterval = 30;
//      [((BaseViewController *)((RDVTabBarController *)[M2AppDelegate.window rootViewController]).selectedViewController) toastMessage:@"请检查您的网络是否连接"];
      [self hideNetworkActivityIndicator];
    });
  }];
}

/*
 异步POST API请求
 */
- (void)asyncRequestWithParams:(NSDictionary *)params andSuccess:(void (^)(id res))success andFailure:(void (^)(NSError *error))failure {
  [self.networkOperation.operationQueue cancelAllOperations];
  [self showNetworkActivityIndicator];
  [self.networkOperation POST:@"api" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      if (success) {
        success(responseObject);
      }
      [self hideNetworkActivityIndicator];
    });
  } failure:^(AFHTTPRequestOperation *operation, NSError *error){
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      if (failure) {
        failure(error);
      }
      // 网络错误
//      [((BaseViewController *)((RDVTabBarController *)[M2AppDelegate.window rootViewController]).selectedViewController) toastMessage:@"请检查您的网络是否连接"];
      [self hideNetworkActivityIndicator];
    });
  }];
}

- (id)syncPostRequestWithParams:(NSDictionary *)params {
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
  
  [urlRequest setTimeoutInterval:60.];
  [urlRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setValue:@"application/json" forHTTPHeaderField:@"content-type"];
  [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [urlRequest setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api", STAGE_URL]]];
  
  NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
  urlRequest.HTTPBody = requestData;
  
  NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
  
  return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

/*
 Description:showing network spinning gear in status bar
 */
- (void)showNetworkActivityIndicator {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
 Description:hide network spinning gear in status bar
 */
- (void)hideNetworkActivityIndicator {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
