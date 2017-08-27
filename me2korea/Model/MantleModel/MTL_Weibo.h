//
//  Weibo.h
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MTL_Weibo : BaseMTLModel <MTLJSONSerializing>

@property (nonatomic, retain) NSNumber * attitudes_count;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSString * profileImageUrl;
@property (nonatomic, retain) NSNumber * reposts_count;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * sourceName;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnail_pic;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSNumber * sortWeight;

@end
