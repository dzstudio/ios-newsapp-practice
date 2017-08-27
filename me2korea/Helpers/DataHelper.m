
//
//  DataHelper.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/7.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "DataHelper.h"
#import "SynthesizeSingleton.h"

@implementation DataHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(DataHelper);

#pragma mark singleton implementation
+ (DataHelper *)instance {
  return [self sharedDataHelper];
}

/*
 根据类型和商店清除淘宝数据
 */
- (void)truncateTaobaoWithType:(NSString *)type andStore:(NSString *)store {
  NSFetchRequest *request = [Taobao MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"type = %@ AND store = %@", type, store] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Taobao MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Taobao *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 根据类型清除微博数据
 */
- (void)truncateWeiboWithType:(NSString *)type {
  NSFetchRequest *request = [Weibo MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"type = %@", type] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Weibo MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Weibo *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 根据类型删除排行榜数据
 */
- (void)truncateToptenWithSite:(NSString *)site {
  NSNumber *sid = [NSDecimalNumber decimalNumberWithString:[Constants.siteIdMap objectForKey:site]];
  NSFetchRequest *request = [Toptenz MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"sid = %@", sid] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Toptenz MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Toptenz *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 根据类型删除排行榜数据
 */
- (void)truncateNewsWithCategory:(NSString *)cat_name {
  NSFetchRequest *request = [News MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"cat_name = %@", cat_name] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [News MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(News *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 根据类型删除视频数据
 */
- (void)truncateVideoWithType:(NSString *)type {
  NSFetchRequest *request = [Video MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"type = %@", type] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Video MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Video *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 根据类型删除韩剧数据
 */
- (void)truncateTVWithType:(NSString *)type andEnd:(BOOL)end {
  NSString *endStr = end ? @"yes" : @"no";
  NSFetchRequest *request = [Teleplay MR_requestAllWithPredicate:[NSPredicate predicateWithFormat:@"type = %@ AND is_end = %@", type, endStr] inContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Teleplay MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Teleplay *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/*
 清空剧本小说数据
 */
- (void)truncateNovels {
  NSFetchRequest *request = [Novel MR_requestAllInContext:[NSManagedObjectContext MR_defaultContext]];
  NSArray *objectsToTruncate = [Novel MR_executeFetchRequest:request inContext:[NSManagedObjectContext MR_defaultContext]];
  NSMutableArray *objs = [NSMutableArray arrayWithArray:objectsToTruncate];
  [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [(Novel *)obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
  }];
  [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
