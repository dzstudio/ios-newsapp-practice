//
//  MTL_News.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_News.h"
#import "NSDate+String.h"

@implementation MTL_News

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"cat_name": @"cat_name",
    @"createTime": @"createTime",
    @"detailPageLink": @"detailPageLink",
    @"msgId": @"msgId",
    @"tag_name": @"tag_name",
    @"thumbLink": @"thumbLink",
    @"title": @"title",
    @"update_time": @"update_time"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"cat_name": @"cat_name"},
    @{@"createTime": @"createTime"},
    @{@"detailPageLink": @"detailPageLink"},
    @{@"msgId": @"msgId"},
    @{@"tag_name": @"tag_name"},
    @{@"thumbLink": @"thumbLink"},
    @{@"title": @"title"},
    @{@"update_time": @"update_time"}
  ];
}

+ (NSValueTransformer *)createTimeJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    // 很奇怪，API三两种时间返回格式
    if (((NSString *)value).length <= 10) {
      return [self.dateFormatter3 dateFromString:value];
    } else if (((NSString *)value).length <= 13) {
      return [self.dateFormatter1 dateFromString:value];
    } else {
      return [self.dateFormatter2 dateFromString:value];
    }
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [self.dateFormatter2 stringFromDate:value];
  }];
}

+ (NSValueTransformer *)update_timeJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    // 很奇怪，API三两种时间返回格式
    if (((NSString *)value).length <= 10) {
      return [self.dateFormatter3 dateFromString:value];
    } else if (((NSString *)value).length <= 13) {
      return [self.dateFormatter1 dateFromString:value];
    } else {
      return [self.dateFormatter2 dateFromString:value];
    }
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [self.dateFormatter2 stringFromDate:value];
  }];
}

@end
