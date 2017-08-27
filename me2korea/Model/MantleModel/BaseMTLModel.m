//
//  BaseMTLModel.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/1.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "BaseMTLModel.h"

@implementation BaseMTLModel

/*
 需要被赋值的属性名称列表
 */
- (NSArray *)propertiesList {
  return [NSArray array];
}

/*
 为传入的对象的属性赋值
 */
- (void)migratePropertiesToObject:(id)obj {
  NSArray *properties = [self propertiesList];
  for (NSDictionary *dict in properties) {
    NSString *from = [[dict allKeys] firstObject];
    NSString *to = [dict objectForKey:from];
    
    // 通过反射机制为对象属性赋值
    id propertyValue = [self valueForKey:from];
    if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
      [obj setValue:propertyValue forKey:to];
    }
  }
}

+ (NSDateFormatter *)dateFormatter1 {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd:HH";
  return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter2 {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-M-d HH:mm:ss"; //"2015-11-01 03:00:00 +0000" or "2015-11-01 11:00:00";
  return dateFormatter;
}

+ (NSDateFormatter *)dateFormatter3 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd"; //"2015-10-31"
    return dateFormatter;
}

@end
