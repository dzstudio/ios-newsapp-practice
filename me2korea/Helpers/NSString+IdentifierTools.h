//
//  NSString+IdentifierTools.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IdentifierTools)

- (NSArray *)camelStyleToArray;
- (NSArray *)dashStyleToArray;
- (NSArray *)underscoreStyleToArray;
+ (NSString *)arrayToCamelStyle:(NSArray *)array;
+ (NSString *)arrayToDashStyle:(NSArray *)array;
+ (NSString *)arrayToUnderscoreStyle:(NSArray *)array;
- (NSString *)capitalizedFirstLetterString;
- (NSString *)lowercaseFirstLetterString;
- (NSString *)substringWithoutLast:(NSUInteger)last;
- (NSString *)substringBetweenSubstrings:(NSString *)startString and:(NSString *)endString;
- (NSString *)trim;
- (NSString *)filterNumbers;
- (NSString *)deleteTagFormat;
- (NSString *)addTagFormat;
- (BOOL)isDeleteTagFormat;

@end
