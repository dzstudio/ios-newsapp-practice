//
//  News+CoreDataProperties.h
//  
//
//  Created by DillonZhang on 15/12/3.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "News.h"

NS_ASSUME_NONNULL_BEGIN

@interface News (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cat_name;
@property (nullable, nonatomic, retain) NSString *detailPageLink;
@property (nullable, nonatomic, retain) NSString *msgId;
@property (nullable, nonatomic, retain) NSString *tag_name;
@property (nullable, nonatomic, retain) NSString *thumbLink;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSDate *update_time;

@end

NS_ASSUME_NONNULL_END
