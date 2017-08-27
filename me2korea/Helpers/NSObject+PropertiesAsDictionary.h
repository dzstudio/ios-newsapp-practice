//
//  NSObject+PropertiesAsDictionary.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertiesAsDictionary)

+ (NSArray *)propertyNamesArray;
+ (NSDictionary *)primitiveTypes;
+ (NSString *)typeFromAttributes:(NSString *)attributes;
+ (NSDictionary *)propertyNamesAttrDictionary;

- (NSDictionary *)propertyValuesDictionary;

@end
