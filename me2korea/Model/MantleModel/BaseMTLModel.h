//
//  BaseMTLModel.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/1.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MTLModel.h"

@interface BaseMTLModel : MTLModel

+ (NSDateFormatter *)dateFormatter1;
+ (NSDateFormatter *)dateFormatter2;
+ (NSDateFormatter *)dateFormatter3;
- (NSArray *)propertiesList;
- (void)migratePropertiesToObject:(id)obj;

@end
