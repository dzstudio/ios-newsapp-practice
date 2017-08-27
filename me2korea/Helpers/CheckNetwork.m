//
//  CheckNetwork.m
//  dillonzhang
//
//  Created by dillonzhang on 15/5/10.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "CheckNetwork.h"
#import "Constants.h"
#import "Reachability.h"

@implementation CheckNetwork

+(BOOL)isExistenceNetwork
{
    	BOOL isExistenceNetwork;
    	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
    			isExistenceNetwork=FALSE;
                break;
            case ReachableViaWWAN:
    			isExistenceNetwork=TRUE;
                break;
            case ReachableViaWiFi:
    			isExistenceNetwork=TRUE;
                break;
        }
    	return isExistenceNetwork;
}

@end
