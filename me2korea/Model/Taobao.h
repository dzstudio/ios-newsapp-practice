//
//  Taobao.h
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Taobao : NSManagedObject

@property (nonatomic, retain) NSString * t_id;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * imgSrc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * saleCount;
@property (nonatomic, retain) NSString * store;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * update_time;

@end
