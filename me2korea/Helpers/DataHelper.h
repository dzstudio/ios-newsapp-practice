//
//  DataHelper.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/7.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (DataHelper *)instance;

- (void)truncateTaobaoWithType:(NSString *)type andStore:(NSString *)store;
- (void)truncateWeiboWithType:(NSString *)type;
- (void)truncateToptenWithSite:(NSString *)site;
- (void)truncateVideoWithType:(NSString *)type;
- (void)truncateTVWithType:(NSString *)type andEnd:(BOOL)end;
- (void)truncateNewsWithCategory:(NSString *)cat_name;
- (void)truncateNovels;

@end
