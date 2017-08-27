//
//  NSDate+ISO8601.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DATE_ISO8601;

@interface NSDate (ISO8601)

+ (NSDate *)dateFromISO8601:(NSString *)string;
- (NSString *)dateAsISO8601String;
- (NSString *)dateAsLogString;

@end
