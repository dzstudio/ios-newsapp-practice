//
//  PlayLinkCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/13.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "PlayLinkCell.h"

@implementation PlayLinkCell

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  self.playButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  [self.playButton.titleLabel setMinimumScaleFactor:0.1];
}

- (void)configCellWith:(NSString *)title andPlanNumber:(NSString *)number andLink:(NSString *)link andTVName:(NSString *)name {
  [self.playButton setTitle:title forState:UIControlStateNormal];
  self.playLink = link;
  self.playNumber = number;
  self.playName = name;
}

@end
