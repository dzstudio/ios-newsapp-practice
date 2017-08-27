//
//  WeiboCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/10.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedTime;
@property (weak, nonatomic) IBOutlet UILabel *labelPlatform;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *labelForward;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *labelHit;
@property (weak, nonatomic) IBOutlet UIImageView *crownImage;

- (void)configCellWithRecord:(Weibo *)record;

@end
