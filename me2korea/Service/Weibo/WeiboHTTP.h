//
//  WeiboHTTP.h
//
//  Created by dillonzhang on 15/5/28.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboHTTP: NSObject

+(void)sendRequestToPath:(NSString*)url method:(NSString*)method params:(NSDictionary*)params  completionHandler:(void (^)(id)) completionHandler ;

+(void)postJsonToPath:(NSString*)url id:object  completionHandler:(void (^)(id)) completionHandler;

@end
