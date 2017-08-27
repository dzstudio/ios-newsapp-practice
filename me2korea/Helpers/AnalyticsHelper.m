//
//  AnalyticsHelper.m
//  ios-newsapp-practice
//
//  Created by dillonzhang on 15/6/15.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

// Umeng
#import "MobClick.h"
#import "AnalyticsHelper.h"
#import "SynthesizeSingleton.h"

#define UMENG_APP_KEY @"557d3f0e67e58ebaf3002413"

@interface AnalyticsHelper()

@end

@implementation AnalyticsHelper

+ (void) start
{
    //[MobClick setLogEnabled:YES];
    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:BATCH   channelId:nil];
    [MobClick setEncryptEnabled:YES];
}

+ (void)beginLogPageView:(NSString *)pageName
{
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName
{
    [MobClick endLogPageView:pageName];
}

+ (void)event:(NSString *)eventId label:(NSString *)label
{
    [MobClick event:eventId label:label];
}

@end
