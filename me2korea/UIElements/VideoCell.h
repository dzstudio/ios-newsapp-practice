//
//  VideoCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer;
@property (weak, nonatomic) IBOutlet UILabel *labelPlayCount;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateDate;

- (void)configCellWithRecord:(Video *)record;

@end
