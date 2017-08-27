//
//  APIProcessor.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/24.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "APIProcessor.h"
#import "RestAPIHelper.h"
#import "SynthesizeSingleton.h"
#import "DataHelper.h"
// 引入MTL模型类
#import "MTL_Taobao.h"
#import "MTL_Teleplay.h"
#import "MTL_Toptenz.h"
#import "MTL_Video.h"
#import "MTL_Weibo.h"
#import "MTL_News.h"
#import "MTL_Novel.h"
#import "NSDate+String.h"

@interface APIProcessor()

@property (nonatomic, strong) RestAPIHelper *apiHelper;

@end

@implementation APIProcessor

SYNTHESIZE_SINGLETON_FOR_CLASS(APIProcessor);

#pragma mark singleton implementation
+ (APIProcessor *)instance {
  return [self sharedAPIProcessor];
}

/*
 调用API设置是否关闭**功能
 */
- (void)videoConfigSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSDictionary *parameters = @{@"action": @"videoConfig", @"time": [[NSDate date] yearMonthDayString], @"version":version};

  [self.apiHelper asyncGetWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    if (success && [res objectForKey:@"mItems"]) {
      success([res objectForKey:@"mItems"]);
    }
  } andFailure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取微博数据
 */
- (void)loadWeiboWithGap:(NSString *)gap andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"weibo", @"gap": gap, @"time": time ? [time dateServerStyle] : @""};
  
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateWeiboWithType:gap];
        
        NSInteger index = 0;
        for (NSDictionary *jsonObject in items) {
          MTL_Weibo *model = [MTLJSONAdapter modelOfClass:MTL_Weibo.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 计算排序权重
          model.sortWeight = [NSNumber numberWithInteger:index];
          index++;
          
          // 创建CoreData对象，并且通过Mantle初始化数据
          Weibo *weibo = [Weibo MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
          [model migratePropertiesToObject:weibo];
          NAILog(@"APIProcessor", @"Entity: %@", weibo);
          needCreateRecord = YES;
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving weibo records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取淘宝数据
 */
- (void)loadTaobaoWithStore:(NSString *)store andType:(NSString *)type andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"taobao", @"store": store, @"type": type, @"time": time ? [time dateServerStyle] : @""};
  
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateTaobaoWithType:type andStore:store];
        
        for (NSDictionary *jsonObject in items) {
          MTL_Taobao *model = [MTLJSONAdapter modelOfClass:MTL_Taobao.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 创建CoreData对象，并且通过Mantle初始化数据
          Taobao *taobao = [Taobao MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
          [model migratePropertiesToObject:taobao];
          NAILog(@"APIProcessor", @"Entity: %@", taobao);
          needCreateRecord = YES;
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving taobao records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取新闻数据
 */
- (void)loadNewsWithCatname:(NSString *)cat andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"newsList", @"cat": cat, @"time": time ? [time dateServerStyle] : @""};
  NAILog(@"APIProcessor", @"API Request: %@", parameters);
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"API Response: %@", res);
    
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateNewsWithCategory:cat];
        
        for (NSDictionary *jsonObject in items) {
          MTL_News *model = [MTLJSONAdapter modelOfClass:MTL_News.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 去除重复数据
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"msgId = %@", model.msgId];
          NSArray *duplicate = [News MR_findAllWithPredicate:predicate];
          
          if (duplicate.count > 0) {
            continue;
          } else {
            // 创建CoreData对象，并且通过Mantle初始化数据
            News *news = [News MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            [model migratePropertiesToObject:news];
            NAILog(@"APIProcessor", @"Entity: %@", news);
            needCreateRecord = YES;
          }
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving toptenz records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取音乐排行榜数据
 */
- (void)loadToptenzWithSite:(NSString *)site andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = nil;
    if ([site isEqualToString:TOPTENSID_HANTEO_DAY]) {
       parameters = @{@"action": @"rank", @"site": site, @"time": time ? [time dateServerStyleHanteoDay] : @""};
    } else if([site isEqualToString:TOPTENSID_NEVER]) {
       parameters = @{@"action": @"rank", @"site": site, @"time": time ? [time dateServerStyleNaver] : @""};
    } else {
       parameters = @{@"action": @"rank", @"site": site, @"time": time ? [time dateServerStyle] : @""};
    }
  
   NAILog(@"APIProcessor", @"API Request: %@", parameters);
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"API Response: %@", res);
    
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateToptenWithSite:site];
        
        for (NSDictionary *jsonObject in items) {
          MTL_Toptenz *model = [MTLJSONAdapter modelOfClass:MTL_Toptenz.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 去除重复数据
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid = %@ AND rank = %d", model.sid, model.rank.integerValue];
          NSArray *duplicate = [Toptenz MR_findAllWithPredicate:predicate];
          if (duplicate.count > 0) {
            continue;
          } else {
            // 创建CoreData对象，并且通过Mantle初始化数据
            Toptenz *topten = [Toptenz MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            [model migratePropertiesToObject:topten];
            NAILog(@"APIProcessor", @"Entity: %@", topten);
            needCreateRecord = YES;
          }
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving toptenz records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取视频数据
 */
- (void)loadVideoWithType:(NSString *)type andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"video", @"type": type, @"time": time ? [time dateServerStyle] : @""};
  
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateVideoWithType:@"teach"];
        
        NSInteger index = 0;
        for (NSDictionary *jsonObject in items) {
          MTL_Video *model = [MTLJSONAdapter modelOfClass:MTL_Video.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 计算排序权重
          model.sortWeight = [NSNumber numberWithInteger:index];
          index++;
          
          // 创建CoreData对象，并且通过Mantle初始化数据
          Video *video = [Video MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
          [model migratePropertiesToObject:video];
          NAILog(@"APIProcessor", @"Entity: %@", video);
          needCreateRecord = YES;
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving video records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取韩剧和综艺
 */
- (void)loadMediaWithType:(NSString *)type andEnd:(BOOL)end andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"video", @"type": type, @"is_end": (end ? @"yes" : @"no"), @"time": time ? [time dateServerStyle] : @""};
  
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateTVWithType:type andEnd:end];
        
        NSInteger index = 0;
        for (NSDictionary *jsonObject in items) {
          MTL_Teleplay *model = [MTLJSONAdapter modelOfClass:MTL_Teleplay.class fromJSONDictionary:jsonObject error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 计算排序权重
          model.sortWeight = [NSNumber numberWithInteger:index];
          index++;
          
          // 创建CoreData对象，并且通过Mantle初始化数据
          Teleplay *teleplay = [Teleplay MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
          [model migratePropertiesToObject:teleplay];
          NAILog(@"APIProcessor", @"Entity: %@", teleplay);
          needCreateRecord = YES;
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving media records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API获取韩剧和综艺
 */
- (void)loadNovelsWithTitle:(NSString *)title andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
  NSDictionary *parameters = @{@"action": @"novel", @"title": title, @"time": time ? [time dateServerStyle] : @""};
  
  [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
    NAILog(@"APIProcessor", @"%@", res);
    // 保存数据到数据库
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([res objectForKey:@"mItems"] != [NSNull null]) {
        NSArray *items = [res objectForKey:@"mItems"];
        NSError *error = nil;
        BOOL needCreateRecord = NO;
        
        // 清空本地数据
        [[DataHelper instance] truncateNovels];
        for (NSDictionary *jsonObject in items) {
          NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithDictionary:jsonObject];
          NSString *desc = [obj objectForKey:@"description"];
          [obj removeObjectForKey:@"description"];
          [obj setObject:desc forKey:@"novel_desc"];
          MTL_Novel *model = [MTLJSONAdapter modelOfClass:MTL_Novel.class fromJSONDictionary:obj error:&error];
          NAILog(@"APIProcessor", @"Data Model: %@", model);
          
          // 创建CoreData对象，并且通过Mantle初始化数据
          Novel *novel = [Novel MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
          [model migratePropertiesToObject:novel];
          
          NSLog(@"%@", novel);
          
          NAILog(@"APIProcessor", @"Entity: %@", novel);
          needCreateRecord = YES;
        }
        if (needCreateRecord) {
          // 通过MagicalRecord将数据保存
          NAILog(@"APIProcessor", @"Saving media records...");
          [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
      }
      
      // 调用回调函数
      if (success) {
        success([res objectForKey:@"mItems"]);
      }
    });
  } andFailure:^(NSError *error) {
    NAILog(@"APIProcessor", @"%@", error);
    // 调用回调函数
    if (failure) {
      failure(error);
    }
  }];
}

/*
 通过API检验是否有排行榜更新
 
 其中site是需要查询的排行榜网站名称，time是客户端已有排行榜数据的更新时间。
 若服务器有新的数据，则将返回{"mItems":[{"has_new":"true","update_time":null}]}，
 若服务器无新的数据，则将返回{"mItems":[{"has_new":"false","update_time":null}]}
 
 客户端应该在特殊时刻（比如用>户切换到当前排行榜界面时）调用这个api。
*/
- (void)checkToptenzUpdateWithSite:(NSString *)site andTime:(NSDate *)time andSuccess:(void (^)(id responseObject))success andFailure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = nil;
    if([site isEqualToString:TOPTENSID_HANTEO_DAY]) {
        parameters = @{@"action": @"checkUpdate", @"site": site, @"time": time ? [time dateServerStyleHanteoDay] : @""};
    } else if([site isEqualToString:TOPTENSID_NEVER]) {
        parameters = @{@"action": @"checkUpdate", @"site": site, @"time": time ? [time dateServerStyleNaver] : @""};
    } else {
        parameters = @{@"action": @"checkUpdate", @"site": site, @"time": time ? [time dateServerStyle] : @""};
    }
    
    NAILog(@"APIProcessor", @"API Request: %@", parameters);
    [self.apiHelper asyncRequestWithParams:parameters andSuccess:^(NSDictionary *res) {
        NAILog(@"APIProcessor", @"API Response: %@", res);
        // 调用回调函数
        if (success) {
            success([res objectForKey:@"mItems"]);
        }
    } andFailure:^(NSError *error) {
        NAILog(@"APIProcessor", @"%@", error);
        // 调用回调函数
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Propertis
- (RestAPIHelper *)apiHelper {
  if (!_apiHelper) {
    _apiHelper = [[RestAPIHelper alloc] init];
  }
  
  return _apiHelper;
}

@end
