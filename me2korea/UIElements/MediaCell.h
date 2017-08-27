//
//  MediaCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelMediaTitle;
@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *labelUpdateInfo;

- (void)configCellWithRecord:(Teleplay *)record;

@end
