//
//  NSDate+String.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

- (NSString *)dayMonthYearString;
+ (NSDate *)dateFromYearMonthDayString:(NSString *)dateString;
- (NSString *)yearMonthDayString;
- (NSString *)dateIncludeYMD;
- (NSString *)dateIncludeHMA;
- (NSString *)dateIncludeYMDHMAZ;
- (NSString *)dateAllPart;
- (NSString *)dateLongStyle;
- (NSString *)dateShortStyle;
- (NSString *)yearMonthDayPSTString;
- (NSString *)datePSTIncludeHMA;
- (NSString *)dateServerStyle;
- (NSString *)dateServerStyleHanteoDay;
- (NSString *)dateServerStyleNaver;
- (NSString *)weiboStyle;
- (NSString *)dateChineseStyle;

+ (NSString *)monthOfDate:(NSString *)date;
+ (NSString *)dayOfDate:(NSString *)date;
+ (NSString *)yearOfDate:(NSString *)date;
@end
