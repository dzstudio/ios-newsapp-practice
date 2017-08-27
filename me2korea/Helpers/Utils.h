//
//  Utils.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/3.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
  float multiplier;
  float constant;
} ConstraintParam;

@interface Utils : NSObject

//是否具备网络链接
@property BOOL isNetworkRunning;

// 单例对象
+ (Utils *)instance;

// Add constraints when addSubView.
- (void)fillParentConstraintsFrom:(UIView *)subView To:(UIView *)superView;
- (void)fillParentConstraintsFrom:(UIView *)subView To:(UIView *)superView withPadding:(ConstraintParam[])constraintParams;
- (void)setConstraintsForSubview:(UIView *)subview withSubviewFrame:(CGRect)subviewFrame WithSuperViewFrame:(CGRect)superviewFrame;

@end
