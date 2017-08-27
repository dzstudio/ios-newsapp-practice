//
//  NovelPagerView.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/11.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePagerView.h"

@interface NovelPagerView : LivePagerView

@property (weak, nonatomic) IBOutlet UIView *tableViewArea;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorViewheight;
@property (weak, nonatomic) IBOutlet UILabel *novelTitle;
@property (weak, nonatomic) IBOutlet UILabel *novelAuthor;
@property (weak, nonatomic) IBOutlet UIImageView *novelPicture;
@property (weak, nonatomic) IBOutlet UITextView *novelDescriptionView;

- (void)initPageFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type;

@end
