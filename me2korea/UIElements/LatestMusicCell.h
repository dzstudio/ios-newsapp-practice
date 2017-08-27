//
//  LatestMusicCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/8.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestMusicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgMusic;
@property (weak, nonatomic) IBOutlet UITextView *txtMusicTitle;
@property (weak, nonatomic) IBOutlet UIView *tipHotMusic;

- (void)configCellWithNews:(News *)record withType:(NSString *)type andIndex:(NSInteger)index;

@end
