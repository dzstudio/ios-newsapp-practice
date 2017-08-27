//
//  UIView+screenshot.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/11/29.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "UIView+screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // get context that can be used to process images graphics
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext(); // get a UIImage object from the current context
    UIGraphicsEndImageContext(); // Close UIImage context

    return screenshot;
}

- (UIImage *)screenshotWithOffset:(CGFloat)deltaY {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //  KEY: need to translate the context down to the current visible portion of the tableview
    CGContextTranslateCTM(ctx, 0, deltaY);
    [self.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return screenshot;
}

@end
