//
//  RestAPIHelper.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/24.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RestAPIHelper : AFHTTPRequestOperation

- (void)asyncGetWithParams:(NSDictionary *)params andSuccess:(void (^)(id res))success andFailure:(void (^)(NSError *error))failure;
- (void)asyncRequestWithParams:(NSDictionary *)params andSuccess:(void (^)(id res))success andFailure:(void (^)(NSError *error))failure;
- (id)syncPostRequestWithParams:(NSDictionary *)params;

@end
