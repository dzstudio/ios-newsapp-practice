//
//  NSDate+ISO8601.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NSDate+ISO8601.h"

NSString *const DATE_ISO8601 = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
NSString *const DATE_LOG = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss.SSS";

@implementation NSDate (ISO8601)

/**
 Description: Return an international standard time format.
 */
+ (NSDateFormatter *)iso8601Formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_ISO8601];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return dateFormatter;
}

/**
 Description: Return a time format to record time for logs.
 */
+ (NSDateFormatter *)logFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_LOG];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return dateFormatter;
}

/**
 Description: Get DateTime from a string and change its format to ISO8601.
 */
+ (NSDate *)dateFromISO8601:(NSString *)string {
    NSDate *resDate = [[[self class] iso8601Formatter] dateFromString:string];
    return resDate;
}

/**
 Description: Convert ISO8601 DateTime to string.
 */
- (NSString *)dateAsISO8601String {
    return [[[self class] iso8601Formatter] stringFromDate:self];
}

/**
 Description: Convert DateTime to string.
 */
- (NSString *)dateAsLogString {
    return [[[self class] logFormatter] stringFromDate:self];
}

@end
