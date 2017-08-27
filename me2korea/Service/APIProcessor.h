//
//  APIProcessor.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/24.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIProcessor : NSObject

// 单例对象
+ (APIProcessor *)instance;

- (void)videoConfigSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取微博数据
 */
- (void)loadWeiboWithGap:(NSString *)gap andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取淘宝数据
 */
- (void)loadTaobaoWithStore:(NSString *)store andType:(NSString *)type andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取音乐排行榜数据
 */
- (void)loadToptenzWithSite:(NSString *)site andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取视频数据
 */
- (void)loadVideoWithType:(NSString *)type andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取韩剧和综艺
 */
- (void)loadMediaWithType:(NSString *)type andEnd:(BOOL)end andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;


/*
 通过API检验是否有排行榜更新
 */
- (void)checkToptenzUpdateWithSite:(NSString *)site andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取新闻数据
 */
- (void)loadNewsWithCatname:(NSString *)cat andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

/*
 通过API获取小说列表数据
 */
- (void)loadNovelsWithTitle:(NSString *)title andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure;

@end
