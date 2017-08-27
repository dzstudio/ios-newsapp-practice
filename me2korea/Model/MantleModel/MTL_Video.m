//
//  Video.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_Video.h"


@implementation MTL_Video

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"author": @"author",
    @"createTime": @"createTime",
    @"imgSrc": @"imgSrc",
    @"playCount": @"playCount",
    @"link": @"link",
    @"title": @"title",
    @"type": @"type",
    @"update_time": @"update_time"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"author": @"author"},
    @{@"createTime": @"createTime"},
    @{@"imgSrc": @"imgSrc"},
    @{@"playCount": @"playCount"},
    @{@"link": @"link"},
    @{@"title": @"title"},
    @{@"type": @"type"},
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

@end
