//
//  Weibo.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_Weibo.h"


@implementation MTL_Weibo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"attitudes_count": @"attitudes_count",
    @"comments_count": @"comments_count",
    @"created_at": @"created_at",
    @"idstr": @"idstr",
    @"profileImageUrl": @"profileImageUrl",
    @"reposts_count": @"reposts_count",
    @"screenName": @"screenName",
    @"sourceName": @"sourceName",
    @"text": @"text",
    @"thumbnail_pic": @"thumbnail_pic",
    @"type": @"type",
    @"uid": @"uid",
    @"update_time": @"update_time"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"attitudes_count": @"attitudes_count"},
    @{@"comments_count": @"comments_count"},
    @{@"created_at": @"created_at"},
    @{@"idstr": @"idstr"},
    @{@"profileImageUrl": @"profileImageUrl"},
    @{@"reposts_count": @"reposts_count"},
    @{@"screenName": @"screenName"},
    @{@"sourceName": @"sourceName"},
    @{@"text": @"text"},
    @{@"thumbnail_pic": @"thumbnail_pic"},
    @{@"type": @"type"},
    @{@"uid": @"uid"},
    @{@"update_time": @"update_time"},
    @{@"sortWeight": @"sortWeight"}
  ];
}

+ (NSValueTransformer *)update_timeJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    // 很奇怪，API有两种时间返回格式
    if (((NSString *)value).length <= 13) {
      return [self.dateFormatter1 dateFromString:value];
    } else {
      return [self.dateFormatter2 dateFromString:value];
    }
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [self.dateFormatter2 stringFromDate:value];
  }];
}

+ (NSValueTransformer *)created_atJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    // 很奇怪，API有两种时间返回格式
    if (((NSString *)value).length <= 0) {
      return [NSDate date];
    } else {
      return [self.dateFormatter2 dateFromString:value];
    }
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [self.dateFormatter2 stringFromDate:value];
  }];
}

@end
