//
//  PlayLinkCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/13.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayLinkCell : UICollectionViewCell

@property (nonatomic, strong) NSString *playLink;
@property (nonatomic, strong) NSString *playName;
@property (nonatomic, strong) NSString *playNumber;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (void)configCellWith:(NSString *)title andPlanNumber:(NSString *)number andLink:(NSString *)link andTVName:(NSString *)name ;

@end
