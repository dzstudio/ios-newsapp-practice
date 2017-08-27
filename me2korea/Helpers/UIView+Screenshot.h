//
//  UIView+screenshot.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/11/29.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage *)screenshotWithOffset:(CGFloat)deltaY;
- (UIImage *)screenshot;

@end
