//
//  NSDate+String.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NSDate+String.h"

#define DAY_MONTH_YEAR_FORMAT @"dd MMMM yyyy"
#define YEAR_MONTH_DAY_FORMAT @"yyyy-MM-dd"
static NSDateFormatter *dateFormater;

@implementation NSDate (String)

/*
 Description: Convert a datetime to string wiht weibo style
 */
- (NSString *)weiboStyle {
  NSTimeInterval time = self.timeIntervalSince1970;
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
  int duration = ceil(now - time);
    
  if(duration <= 0) {
      duration = 60;
  }
  
  // Seconds
  if (duration < 60) {
    return [NSString stringWithFormat:@"%d秒前", duration];
  }
  
  // Minitues
  if (duration < 60 * 60) {
    return [NSString stringWithFormat:@"%d分钟前", (int)ceil(duration / 60)];
  }
  
  // Hours
  if (duration < 60 * 60 * 24) {
    return [NSString stringWithFormat:@"%d小时前", (int)ceil(duration / (60 * 60))];
  }
  
  // Days
  if (duration < 60 * 60 * 24 * 20) {
    return [NSString stringWithFormat:@"%d天前", (int)ceil(duration / (60 * 60 * 24))];
  }
  
  // Date
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
  return [NSString stringWithFormat:@"%d - %d", (int)[dateComponent month], (int)[dateComponent day]];
}

/*
 Description:Convert a datetime to a string with format 'day-month-year'.
 */
- (NSString *)dayMonthYearString {
    return [self dateStringAccordingFormat:DAY_MONTH_YEAR_FORMAT];
}

/**
 Description: Convert a datetime to a string with a specified foramt.
 */
- (NSString *)dateStringAccordingFormat:(NSString *)format {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:format];

    return [dateFormater stringFromDate:self];
}

/**
 Description: Convert a string to datetime with specified format "yyyy-MM-dd".
 */
+ (NSDate *)dateFromYearMonthDayString:(NSString *)dateString {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:YEAR_MONTH_DAY_FORMAT];
    return [dateFormater dateFromString:dateString];
}

/**
 Description: Convert a datetime to string with specified format "yyyy-MM-dd".
 */
- (NSString *)yearMonthDayString {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:YEAR_MONTH_DAY_FORMAT];
    return [dateFormater stringFromDate:self];
}

/**
 Description: Convert a datetime to PST string with specified format "yyyy-MM-dd".
 */
- (NSString *)yearMonthDayPSTString {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:YEAR_MONTH_DAY_FORMAT];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
    return [dateFormater stringFromDate:self];
}

/*
 Description: PST Time String. H, hour. M, minutes. A, PM/AM
 */
- (NSString *)datePSTIncludeHMA {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"hh:mm aa"];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
    return [dateFormater stringFromDate:self];
}

/*
 Description: Y, year. M month. D Day.
 */
- (NSString *)dateIncludeYMD {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"MM/dd/yyyy"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM
 */
- (NSString *)dateIncludeHMA {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"hh:mm aa"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM, Z timezone
 */
- (NSString *)dateIncludeYMDHMAZ {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"YYYY-MM-dd h:mm a"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM
 */
- (NSString *)dateAllPart {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"MM/dd/yy hh:mm a"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM
 */
- (NSString *)dateServerStyle {
  if (!dateFormater) {
    dateFormater = [[NSDateFormatter alloc] init];
  }
  [dateFormater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
  return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM
 */
- (NSString *)dateServerStyleHanteoDay {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"YYYY-MM-dd"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: H, hour. M, minutes. A, PM/AM
 */
- (NSString *)dateServerStyleNaver {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateFormat:@"YYYY-M-d HH:mm:ss"];
    return [dateFormater stringFromDate:self];
}

/*
 Description: "November 23, 1937” or “3:30:32pm"
 */
- (NSString *)dateLongStyle {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateStyle:NSDateFormatterLongStyle];
    [dateFormater setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormater stringFromDate:self];
}

/*
 Description: Convert date string without time "November 23, 1937”
 */
- (NSString *)dateShortStyle {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
    }
    [dateFormater setDateStyle:NSDateFormatterLongStyle];
    [dateFormater setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormater stringFromDate:self];
}

- (NSString *)dateChineseStyle {
  if (!dateFormater) {
    dateFormater = [[NSDateFormatter alloc] init];
  }
  [dateFormater setDateFormat:@"上次更新 M月d日 HH:mm"];
  return [dateFormater stringFromDate:self];
}

+ (NSString *)monthOfDate:(NSString *)date {
    NSRange firstSlash = [date rangeOfString:@"/"];
    if (firstSlash.location == NSNotFound) {
        NSString *month = [date substringToIndex:2];
        return month;
    }
    NSString *month = [date substringToIndex:firstSlash.location];
    if (month.length == 1) {
        return [NSString stringWithFormat:@"0%@", month];
    }
    return month;
}

+ (NSString *)dayOfDate:(NSString *)date {
    NSRange slash = [date rangeOfString:@"/"];
    if (slash.location == NSNotFound) {
        NSString *day = [[date substringFromIndex:2] substringToIndex:2];
        return day;
    }
    NSString *dayBegin = [date substringFromIndex:slash.location + 1];
    slash = [dayBegin rangeOfString:@"/"];
    NSString *day = [dayBegin substringToIndex:slash.location];
    if (day.length == 1) {
        return [NSString stringWithFormat:@"0%@", day];
    }
    return day;
}

+ (NSString *)yearOfDate:(NSString *)date {
    NSRange slash = [date rangeOfString:@"/"];
    if (slash.location == NSNotFound) {
        NSString *year = [date substringFromIndex:4];
        if (year.length == 2) {
            return [NSString stringWithFormat:@"19%@", year];
        }
        return year;
    }
    NSString *dayBegin = [date substringFromIndex:slash.location + 1];
    slash = [dayBegin rangeOfString:@"/"];
    NSString *year = [dayBegin substringFromIndex:slash.location + 1];
    if (year.length == 2) {
        return [NSString stringWithFormat:@"19%@", year];
    }
    return year;
}

@end
