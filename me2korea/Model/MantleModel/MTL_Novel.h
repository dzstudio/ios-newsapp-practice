//
//  MTL_Novel.h
//
//
//  Created by DillonZhang on 15/12/23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MTL_Novel : BaseMTLModel <MTLJSONSerializing>

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * nid;
@property (nonatomic, retain) NSString * novel_desc;
@property (nonatomic, retain) NSString * picLink;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * update_time;

@end
