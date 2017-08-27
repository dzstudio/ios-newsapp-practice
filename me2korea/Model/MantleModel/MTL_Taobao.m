//
//  Taobao.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_Taobao.h"


@implementation MTL_Taobao

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"t_id": @"t_id",
    @"commentCount": @"commentCount",
    @"imgSrc": @"imgSrc",
    @"link": @"link",
    @"name": @"name",
    @"price": @"price",
    @"saleCount": @"saleCount",
    @"store": @"store",
    @"type": @"type",
    @"update_time": @"update_time"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"t_id": @"t_id"},
    @{@"commentCount": @"commentCount"},
    @{@"imgSrc": @"imgSrc"},
    @{@"link": @"link"},
    @{@"name": @"name"},
    @{@"price": @"price"},
    @{@"saleCount": @"saleCount"},
    @{@"store": @"store"},
    @{@"type": @"type"},
    @{@"update_time": @"update_time"}
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

+ (NSValueTransformer *)priceJSONTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [NSDecimalNumber decimalNumberWithString:value];
  } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error){
    return [((NSDecimalNumber *)value) stringValue];
  }];
}

@end
