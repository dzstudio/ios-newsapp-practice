//
//  NSObject+PropertiesAsDictionary.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NSObject+PropertiesAsDictionary.h"
#import "NSString+IdentifierTools.h"

#import "objc/runtime.h"
#import "NSDate+ISO8601.h"

@implementation NSObject (PropertiesAsDictionary)

#pragma mark - Static methods to manage properties
/**
 Description: Get the property name from a property list and add these property names in an array.
 */
+ (NSArray *)propertyNamesArray {
    NSMutableArray *propArr = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *objProperties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = objProperties[i];
        const char *propName = property_getName(property);
        if (propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [propArr addObject:propertyName];
        }
    }
    free(objProperties);
    return [NSArray arrayWithArray:propArr];
}

/**
 Description: Return a dictionary with objects and related values.
 */
+ (NSDictionary *)primitiveTypes {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"SEL", @":", @"void", @"v", @"char", @"c", @"double", @"d", @"float", @"f", @"id", @"@", @"int", @"i", @"long double", @"D", @"long int", @"l", @"long long int", @"q", @"short int", @"s", @"unsigned int", @"I", @"unsigned long int", @"L", @"unsigned long long int", @"Q", @"unsigned short int", @"S", @"struct", @"}", nil];
}

/**
 Description: Return a string value which get from a given string.
 */
+ (NSString *)typeFromAttributes:(NSString *)attributes {
    NSString *resStr = @"";
    if (([attributes characterAtIndex:1] == '@') && ([attributes characterAtIndex:2] == '"')) {
        resStr = [attributes substringBetweenSubstrings:@"@\"" and:@"\","];
        return [NSString stringWithFormat:@"%@*", resStr];
    }
    NSString *simpleAttr = [attributes substringBetweenSubstrings:@"T" and:@","];
    resStr = [[[self class] primitiveTypes] objectForKey:[simpleAttr substringFromIndex:simpleAttr.length - 1]];
    for (int i = 0; i < simpleAttr.length; i++) {
        if ([simpleAttr characterAtIndex:i] == '^') {
            resStr = [NSString stringWithFormat:@"%@*", resStr];
        } else
            break;
    }

    return [NSString stringWithFormat:@"%@", resStr];
}

/**
 Description: Return a dictionary which made up by property names and attributes from a given property list.
 */
+ (NSDictionary *)propertyNamesAttrDictionary {
    NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *objProperties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = objProperties[i];
        const char *propName = property_getName(property);

        if (propName) {
            const char *propAttr = property_getAttributes(property);
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *propertyAttr = [NSString stringWithCString:propAttr encoding:NSUTF8StringEncoding];
            [propDict setObject:[[self class] typeFromAttributes:propertyAttr] forKey:propertyName];
        }
    }
    free(objProperties);

    return [NSDictionary dictionaryWithDictionary:propDict];
}

/**
 Description: Return a dictionary which made up by a given property list object.
 */
- (NSDictionary *)propertyValuesDictionary {
    Class selfClass = [self class];
    u_int count;

    objc_property_t *properties = class_copyPropertyList(selfClass, &count);
    NSMutableDictionary *propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);

        NSString *key = [NSString stringWithCString:propertyName encoding:NSASCIIStringEncoding];
        @try {
            id value = [self valueForKey:key];
            if (value)
                [propertyDictionary setObject:value forKey:key];
        } @catch (NSException *exception) {
            // Avoid crash
        }
    }
    free(properties);

    return [NSDictionary dictionaryWithDictionary:propertyDictionary];
}

- (void)dumpInfo {
    Class selfClass = [self class];
    u_int count;

    Ivar *ivars = class_copyIvarList(selfClass, &count);
    NSMutableArray *ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);

    objc_property_t *properties = class_copyPropertyList(selfClass, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);

    Method *methods = class_copyMethodList(selfClass, &count);
    NSMutableArray *methodArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        const char *methodName = sel_getName(selector);
        [methodArray addObject:[NSString stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
}

@end
