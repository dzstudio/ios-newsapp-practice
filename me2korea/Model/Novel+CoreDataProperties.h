//
//  Novel+CoreDataProperties.h
//  
//
//  Created by DillonZhang on 15/12/24.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Novel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Novel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *nid;
@property (nullable, nonatomic, retain) NSString *novel_desc;
@property (nullable, nonatomic, retain) NSString *picLink;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *update_time;

@end

NS_ASSUME_NONNULL_END
