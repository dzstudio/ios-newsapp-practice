//
//  Utils.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/3.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "Utils.h"
#import "SynthesizeSingleton.h"

@implementation Utils

@synthesize isNetworkRunning;

SYNTHESIZE_SINGLETON_FOR_CLASS(Utils);

#pragma mark singleton implementation
+ (Utils *)instance {
  return [self sharedUtils];
}

#pragma mark - Constraints for addSubView
/**
 Description: Add constraints when add subView to superView.
 @param superView: SuperView.
 @param subView: SubView.
 */
- (void)fillParentConstraintsFrom:(UIView *)subView To:(UIView *)superView {
  [self fillParentConstraintsFrom:subView To:superView withPadding:nil];
}

/**
 Description: Add constraints when add subView to superView.
 @param superView: SuperView.
 @param subView: SubView.
 @param constraintParams: Constraints for padding.
 */
- (void)fillParentConstraintsFrom:(UIView *)subView To:(UIView *)superView withPadding:(ConstraintParam[])constraintParams {
  // Remove existed constraints between superView and subView before add new
  // constraints.
  if (subView.superview) {
    [subView removeFromSuperview];
  }
  
  // If constraint params is nil, set them to default value.
  if (!constraintParams) {
    ConstraintParam constraints[4];
    for (int i = 0; i < 4; i++) {
      constraints[i].multiplier = 1.0f;
      constraints[i].constant = 0.0f;
    }
    constraintParams = constraints;
  }
  
  // Add new constraints to superView.
  subView.translatesAutoresizingMaskIntoConstraints = NO;
  [superView addSubview:subView];
  
  [superView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:constraintParams[0].multiplier constant:constraintParams[0].constant]];
  [superView addConstraint:[NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeLeading multiplier:constraintParams[1].multiplier constant:constraintParams[1].constant]];
  [superView addConstraint:[NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeBottom multiplier:constraintParams[2].multiplier constant:constraintParams[2].constant]];
  [superView addConstraint:[NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:subView attribute:NSLayoutAttributeTrailing multiplier:constraintParams[3].multiplier constant:constraintParams[3].constant]];
  [superView layoutIfNeeded];
}

/**
 Description: Set constraints by giving frame and view which need set.
 @param subview: Subview which need set constraints.
 @param subviewFrame: Giving expect frame.
 */
- (void)setConstraintsForSubview:(UIView *)subview withSubviewFrame:(CGRect)subviewFrame WithSuperViewFrame:(CGRect)superviewFrame {
  // Remove existed constraints between superView and subView before add new
  // constraints.
  subview.translatesAutoresizingMaskIntoConstraints = NO;
  UIView *superview;
  if (subview.superview) {
    superview = subview.superview;
  } else {
    superview = [[UIView alloc] initWithFrame:superviewFrame];
  }
  
  if ([subview.subviews count] == 0) {
    [subview removeConstraints:subview.constraints];
  }
  
  for (NSLayoutConstraint *constraint in superview.constraints) {
    if (constraint.firstItem == subview || constraint.secondItem == subview) {
      [superview removeConstraint:constraint];
    }
  }
  
  // Calculate each direction constraint's multiplier.
  CGFloat topMultiplier = subviewFrame.origin.y / superviewFrame.size.height;
  CGFloat bottomMultiplier = superviewFrame.size.height / (subviewFrame.origin.y + subviewFrame.size.height);
  CGFloat leadingMultiplier = subviewFrame.origin.x / superviewFrame.size.width;
  CGFloat trailingMultiplier = superviewFrame.size.width / (subviewFrame.origin.x + subviewFrame.size.width);
  
  // Add each direction's constraint for superview.
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:topMultiplier constant:0.0f]];
  
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeBottom multiplier:bottomMultiplier constant:0.0f]];
  
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTrailing multiplier:leadingMultiplier constant:0.0f]];
  
  [superview addConstraint:[NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeTrailing multiplier:trailingMultiplier constant:0.0f]];
  
  // Update layout.
  [superview layoutIfNeeded];
}

@end
