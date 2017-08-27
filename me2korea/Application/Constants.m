//
//  Constants.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/12.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSDictionary *)siteIdMap {
  //return @{@"hanteo_real": @"1", @"hanteo_day": @"2", @"mnet": @"3", @"melon": @"4", @"bugs": @"5", @"naver": @"6", @"daum": @"7"};
  return @{@"hanteo_real": @"1", @"hanteo_day": @"2", @"mnet": @"3", @"melon": @"4", @"bugs": @"5", @"naver": @"6"};
}

+ (NSArray *)autoRefreshPagers {
  return @[@"WeiboPagerView", @"MarketPagerView", @"MediaPagerView", @"LivePagerView"];
}

@end
