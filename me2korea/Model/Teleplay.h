//
//  Teleplay.h
//  
//
//  Created by DillonZhang on 15/6/29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Teleplay : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * entryId;
@property (nonatomic, retain) NSString * firstTime;
@property (nonatomic, retain) NSString * imgSrc;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * is_end;
@property (nonatomic, retain) NSDate * last_update_time;
@property (nonatomic, retain) id playLinks;
@property (nonatomic, retain) NSString * titleCn;
@property (nonatomic, retain) NSString * titleEn;
@property (nonatomic, retain) NSNumber * totalCount;
@property (nonatomic, retain) NSString * tvStation;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSString * writer;
@property (nonatomic, retain) NSNumber * sortWeight;

@end
