//
//  NSObject+PropertyPersistance.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/27.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyPersistance)

- (void)loadProperties:(NSString *)fileName;
- (void)saveProperties:(NSString *)fileName;
- (void)setPersistanceOn:(NSString *)pFileName;
- (void)setPersistanceOff;
- (void)persistanceCleanProperties:(NSString *)pFileName;

@end
