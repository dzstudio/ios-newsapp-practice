//
//  Toptenz.h
//  
//
//  Created by DillonZhang on 15/5/24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MTL_Toptenz : BaseMTLModel <MTLJSONSerializing>

@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * album_cn;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * artist_cn;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * extern_link;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * title_cn;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSNumber * translate;
@property (nonatomic, retain) NSNumber * currentLanguage;

@end
