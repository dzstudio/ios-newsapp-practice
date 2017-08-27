//
//  ToptenCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/31.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToptenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *budgetIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelRank;
@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelArtist;
@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;

- (void)configCellWithRecord:(Toptenz *)record withType:(NSString *)type;

@end
