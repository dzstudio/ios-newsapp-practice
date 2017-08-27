//
//  NSObject+PropertyPersistance.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "NSObject+PropertyPersistance.h"
#import "NSObject+PropertiesAsDictionary.h"

#define kEncryptKey @"infoDict"
#define kKeyForDict @"key"

@implementation NSObject (PropertyPersistance)

/**
 Description: Get the path for plist file.
 */
- (NSString *)getPersistPathFilename:(NSString *)pFileName {
    // Get the file name format.
    NSString *fileName = [NSString stringWithFormat:@"%@.plist", NSStringFromClass([self class])];
    // Set name for file name if the given file name is not nil.
    if (pFileName) {
        fileName = pFileName;
    }
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [documentPath stringByAppendingPathComponent:fileName];
    return plistPath;
}

/**
 Description: Get the dictionary from plist file and then set values for the keys in this dictionary.
 */
- (void)loadProperties:(NSString *)pFileName {
    // Load data from file.
    NSDictionary *tempDict = [NSDictionary dictionaryWithContentsOfFile:[self getPersistPathFilename:pFileName]];
    if (tempDict.count == 1 && [tempDict.allKeys containsObject:kKeyForDict]) {
        NSData *data = [tempDict objectForKey:kKeyForDict];
        // Convert the NSData to a dictionary.
        NSDictionary *propertyDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self setValuesForKeysWithDictionary:propertyDict];
    } else {
        [self setValuesForKeysWithDictionary:tempDict];
    }
}

/**
 Description: Encrypt the dictionary and save it to plist file.
 */
- (void)saveProperties:(NSString *)pFileName {
    NSDictionary *propertyDict = [self propertyValuesDictionary];
    // Convert the dictionary to NSData.
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:propertyDict];
    // Write data to file.
    NSString *filePath = [self getPersistPathFilename:pFileName];
    [[NSDictionary dictionaryWithObject:archivedData forKey:kKeyForDict] writeToFile:filePath atomically:YES];

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:filePath error:nil];
}

/**
 Description: Add observer for each key in the plist file.
 */
- (void)setPersistanceOn:(NSString *)pFileName {
    [self loadProperties:pFileName];
    NSDictionary *propertyAttrDict = [self.class propertyNamesAttrDictionary];
    for (NSString *key in propertyAttrDict.keyEnumerator) {
        [self addObserver:self forKeyPath:key options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)context:(__bridge void *)(pFileName)];
    }
}

/**
 Description: Remove observer for each key.
 */
- (void)setPersistanceOff {
    NSDictionary *propertyAttrDict = [self.class propertyNamesAttrDictionary];
    for (NSString *key in propertyAttrDict.keyEnumerator) {
        @try {
            [self removeObserver:self forKeyPath:key];
        } @catch (NSException *exception) {
            NADLog(@"Preferences", @"Failed to remove observer for property: %@", key);
        }
    }
}

/**
 Description: Observe the value change for each key and save the value into plist file.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSString *fileName = (__bridge NSString *)context;
    [self saveProperties:fileName];
}

/**
 Description: Clear the value for keys.
 */
- (void)persistanceCleanProperties:(NSString *)pFileName {
    NSDictionary *cleanDict = [NSDictionary dictionary];
    [cleanDict writeToFile:[self getPersistPathFilename:pFileName] atomically:YES];
    NSDictionary *propertyAttrDict = [self.class propertyNamesAttrDictionary];
    [self setPersistanceOff]; // Remove observer for each key to save time for set all values to nil
    for (NSString *key in propertyAttrDict.keyEnumerator) {
        id value = [self valueForKey:key];
        if (value != nil) {
            [self setValue:nil forKey:key];
        }
    }
    // Save data - once completing clear dictionary data
    [self saveProperties:nil];
    // Open observe as app need continue to save application_version/application_build when logout.
    [self setPersistanceOn:nil];
}

@end
