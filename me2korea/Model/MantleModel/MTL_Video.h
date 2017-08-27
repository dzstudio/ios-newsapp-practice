//
//  Video.h
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MTL_Video : BaseMTLModel <MTLJSONSerializing>

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * imgSrc;
@property (nonatomic, retain) NSNumber * playCount;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSNumber * sortWeight;

@end
