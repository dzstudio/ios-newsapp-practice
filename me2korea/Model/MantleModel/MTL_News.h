//
//  MTL_News.h
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MTL_News : BaseMTLModel <MTLJSONSerializing>

@property (nonatomic, retain) NSString *cat_name;
@property (nonatomic, retain) NSDate *createTime;
@property (nonatomic, retain) NSString *detailPageLink;
@property (nonatomic, retain) NSString *msgId;
@property (nonatomic, retain) NSString *tag_name;
@property (nonatomic, retain) NSString *thumbLink;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *update_time;

@end
