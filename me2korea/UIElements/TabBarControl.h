//
//  TabBarControl.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>

- (void)onTabItemIndex:(NSInteger)index;

@end

@interface TabBarControl : UIView

@property (nonatomic, strong) id<TabBarDelegate> tabDelegate;

- (void)setupWithTitles:(NSArray *)titles andDelegate:(id<TabBarDelegate>)delegate;
- (void)setSelectedTabWith:(NSInteger)index;

@end
