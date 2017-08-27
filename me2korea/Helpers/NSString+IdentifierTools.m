//
//  NSString+IdentifierTools.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NSString+IdentifierTools.h"

#define NUMBERS @"0123456789"

@implementation NSString (IdentifierTools)

/*
 Description: Returns an array, get each word from a given string and then save them into an array with lowercase.
 */
- (NSArray *)camelStyleToArray {
  NSMutableArray *words = [NSMutableArray array];
  NSString *word = @"";
  for (NSUInteger i = 0; i < self.length; i++) {
    char c = [self characterAtIndex:i];
    if (((c >= 'A') && (c <= 'Z')) || ((c >= '0') && (c <= '9'))) {
      if (![word isEqualToString:@""]) {
        [words addObject:[word lowercaseString]];
      }
      word = @"";
    }
    word = [NSString stringWithFormat:@"%@%c", word, c];
  }
  if (![word isEqualToString:@""]) {
    [words addObject:[word lowercaseString]];
  }
  return words;
}

/*
 Description: Returns an array, get the character array from a string by removing "-".
 */
- (NSArray *)dashStyleToArray {
  return [[self lowercaseString] componentsSeparatedByString:@"-"];
}

/*
 Description: Returns an array, get the character array from a string by removing "_".
 */
- (NSArray *)underscoreStyleToArray {
  return [[self lowercaseString] componentsSeparatedByString:@"_"];
}

/*
 Description: Returns a lowercase string.
 */
+ (NSString *)arrayToCamelStyle:(NSArray *)array {
  NSMutableArray *resArray = [NSMutableArray array];
  for (NSString *word in array) {
    [resArray addObject:[word capitalizedFirstLetterString]];
  }
  return [[resArray componentsJoinedByString:@""] lowercaseFirstLetterString];
}

/*
 Description: Returns an array which joined by "-".
 */
+ (NSString *)arrayToDashStyle:(NSArray *)array {
  return [array componentsJoinedByString:@"-"];
}

/*
 Description: Returns a string which joined by "_".
 */
+ (NSString *)arrayToUnderscoreStyle:(NSArray *)array {
  return [array componentsJoinedByString:@"_"];
}

/*
 Description: Change the first letter of a string to Capitalized.
 */
- (NSString *)capitalizedFirstLetterString {
  if (self.length > 0) {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self substringToIndex:1] capitalizedString]];
  }
  return self;
}

/*
 Description: Change the first letter of a string to lowercase.
 */
- (NSString *)lowercaseFirstLetterString {
  if (self.length > 0) {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[self substringToIndex:1] lowercaseString]];
  }
  return self;
}

/*
 Description: Get string from the begining to the given index.
 */
- (NSString *)substringWithoutLast:(NSUInteger)last {
  if (last <= self.length) {
    return [self substringToIndex:self.length - last];
  }
  return @"";
}

/*
 Description: Truncate a string with a specified range.
 */
- (NSString *)substringBetweenSubstrings:(NSString *)startString and:(NSString *)endString {
  NSRange startName = [self rangeOfString:startString];
  NSRange endName = [self rangeOfString:endString];
  NSString *resStr = @"";
  if ((startName.location < self.length) && (endName.location < self.length)) {
    if (startName.location + startName.length < endName.location) {
      resStr = [self substringWithRange:NSMakeRange(startName.location + startName.length, endName.location - startName.location - startName.length)];
    }
  }
  return resStr;
}

/*
 Description: Remove space from a string.
 */
- (NSString *)trim {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/*
 Description: Filter numbers from a given string.
 */
- (NSString *)filterNumbers {
  NSCharacterSet *cs;
  cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
  return [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
}

/*
 Description: Using ChargeSmart Server API to tag an Item , should format this string. The first letter must be not  @"-"
 */
- (NSString *)addTagFormat {
  if ([self rangeOfString:@"-"].location == 0) {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
  } else {
    return self;
  }
}

/*
 Description: If delete a tag , The first letter must be @"-",  This method will format string like this @" -XXX ", This is API Required.
 */
- (NSString *)deleteTagFormat {
  if ([self rangeOfString:@"-"].location == 0) {
    return self;
  } else {
    return [NSString stringWithFormat:@"-%@", self];
  }
}

/*
 Description: If this string fist letter is "-" retrun YES.
 */
- (BOOL)isDeleteTagFormat {
  NSRange resultRange = [self rangeOfString:@"-"];
  return resultRange.length > 0 && resultRange.location == 0;
}

@end
