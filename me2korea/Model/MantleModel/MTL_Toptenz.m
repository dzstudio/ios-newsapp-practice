//
//  Toptenz.m
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import "MTL_Toptenz.h"
#import "NSDate+String.h"

@implementation MTL_Toptenz

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"album": @"album",
    @"album_cn": @"album_cn",
    @"artist": @"artist",
    @"artist_cn": @"artist_cn",
    @"avatar": @"avatar",
    @"extern_link": @"extern_link",
    @"rank": @"rank",
    @"sid": @"sid",
    @"title": @"title",
    @"title_cn": @"title_cn",
    @"type": @"type",
    @"update_time": @"update_time",
    @"translate": @"translate",
    @"currentLanguage": @"currentLanguage"
  };
}

/*
 重写用于赋值的属性列表
 */
- (NSArray *)propertiesList {
  return @[
    @{@"album": @"album"},
    @{@"album_cn": @"album_cn"},
    @{@"artist": @"artist"},
    @{@"artist_cn": @"artist_cn"},
    @{@"avatar": @"avatar"},
    @{@"extern_link": @"extern_link"},
    @{@"rank": @"rank"},
    @{@"sid": @"sid"},
    @{@"title": @"title"},
    @{@"title_cn": @"title_cn"},
    @{@"type": @"type"},
    @{@"update_time": @"update_time"},
    @{@"translate": @"translate"},
    @{@"currentLanguage": @"currentLanguage"}
  ];
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
