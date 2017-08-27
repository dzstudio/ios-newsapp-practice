//
//  Teleplay.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_Teleplay.h"


@implementation MTL_Teleplay

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"actor": @"actor",
    @"alias": @"alias",
    @"area": @"area",
    @"director": @"director",
    @"entryId": @"entryId",
    @"firstTime": @"firstTime",
    @"imgSrc": @"imgSrc",
    @"info": @"info",
    @"is_end": @"is_end",
    @"last_update_time": @"last_update_time",
    @"titleCn": @"titleCn",
    @"titleEn": @"titleEn",
    @"totalCount": @"totalCount",
    @"tvStation": @"tvStation",
    @"type": @"type",
    @"update_time": @"update_time",
    @"writer": @"writer",
    @"playLinks": @"playLinks"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"actor": @"actor"},
    @{@"alias": @"alias"},
    @{@"area": @"area"},
    @{@"director": @"director"},
    @{@"entryId": @"entryId"},
    @{@"firstTime": @"firstTime"},
    @{@"imgSrc": @"imgSrc"},
    @{@"info": @"info"},
    @{@"is_end": @"is_end"},
    @{@"last_update_time": @"last_update_time"},
    @{@"titleCn": @"titleCn"},
    @{@"titleEn": @"titleEn"},
    @{@"totalCount": @"totalCount"},
    @{@"tvStation": @"tvStation"},
    @{@"type": @"type"},
    @{@"update_time": @"update_time"},
    @{@"writer": @"writer"},
    @{@"playLinks": @"playLinks"},
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

+ (NSValueTransformer *)last_update_timeJSONTransformer {
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

+ (NSValueTransformer *)totalCountJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [NSNumber numberWithInt:[NSDecimalNumber decimalNumberWithString:value].intValue];
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [((NSNumber *)value) stringValue];
  }];
}

@end
