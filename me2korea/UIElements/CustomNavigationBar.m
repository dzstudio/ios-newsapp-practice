//
//  CustomNavigationBar.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

/*
 通过xib初始导航栏UI
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [[NSBundle mainBundle] loadNibNamed:@"CustomNavigationBar" owner:self options:nil];
  [self addSubview:self.navigationView];
  [self hideAllButtons];
  
  return self;
}

- (void)setTitle:(NSString *)title {
  self.labelTitleView.text = title;
}

- (void)hideAllButtons {
  self.btnSwitch.hidden = YES;
  self.btnBack.hidden = YES;
  self.btnShare.hidden = YES;
}

@end
