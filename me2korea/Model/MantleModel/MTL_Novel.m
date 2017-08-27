//
//  MTL_Novel.m
//
//
//  Created by DillonZhang on 15/12/23.
//
//

#import "MTL_Novel.h"
#import "NSDate+String.h"

@implementation MTL_Novel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"author": @"author",
    @"nid": @"nid",
    @"novel_desc": @"novel_desc",
    @"picLink": @"picLink",
    @"title": @"title",
    @"update_time": @"update_time"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"author": @"author"},
    @{@"nid": @"nid"},
    @{@"novel_desc": @"novel_desc"},
    @{@"picLink": @"picLink"},
    @{@"title": @"title"},
    @{@"update_time": @"update_time"}
  ];
}

+ (NSValueTransformer *)update_timeJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    if (((NSString *)value).length == 0) {
      return [NSDate date];
    }
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
