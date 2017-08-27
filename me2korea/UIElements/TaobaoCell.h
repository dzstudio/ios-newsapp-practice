//
//  TaobaoCell.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaobaoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UILabel *labelSoldCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentsCount;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITextView *textProductName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace4;

- (void)configCellWithRecord:(Taobao *)record withType:(NSString *)type;

@end
