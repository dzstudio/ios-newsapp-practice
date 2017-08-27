//
//  TabBarControl.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "TabBarControl.h"

#define TITLE_VIEW_TAG 21
#define LINE_VIEW_TAG  22

@interface TabBarControl() {
  NSMutableArray *_tabBarItems;
  NSInteger _selectedIndex;
}

@end

@implementation TabBarControl

- (void)setupWithTitles:(NSArray *)titles andDelegate:(id<TabBarDelegate>)delegate {
  if (delegate) {
    self.tabDelegate = delegate;
  }
  
  if (titles.count <= 0) {
    return;
  }
  
  _tabBarItems = [NSMutableArray array];
  _selectedIndex = 0;
  CGFloat tabWidth = self.frame.size.width / titles.count;
  CGFloat tabHeight = self.frame.size.height;
  CGFloat initOffset = 0.0;
  
  for (NSString *title in titles) {
    // 生成tab
    UIView *tabView = [[UIView alloc] initWithFrame:CGRectMake(initOffset, 0, tabWidth, tabHeight)];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:(CGRect){0, 0, tabView.frame.size}];
    
    // 生成title
    labelTitle.text = title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:tabHeight * 0.4];
    labelTitle.textColor = [UIColor colorWithHexString:@"#16C5BB"];
    labelTitle.tag = TITLE_VIEW_TAG;
    [tabView addSubview:labelTitle];
    
    // 生成分隔线
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    seperator.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [tabView addSubview:seperator];
    
    // 生成高亮线
    UIView *selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, tabHeight - 1, tabWidth, 1)];
    selectedLine.backgroundColor = [UIColor colorWithHexString:@"#16C5BB"];
    selectedLine.tag = LINE_VIEW_TAG;
    [tabView addSubview:selectedLine];
    if ([titles indexOfObject:title] != _selectedIndex) {
      selectedLine.hidden = YES;
      labelTitle.textColor = [UIColor colorWithHexString:@"#2D3F58"];
    }
    
    // 绑定点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTabTaped:)];
    [tabView addGestureRecognizer:tap];
    
    [_tabBarItems addObject:tabView];
    [self addSubview:tabView];
    initOffset += tabWidth;
  }
}

/*
 通过索引设置当前选中的tab的样式
 */
- (void)setSelectedTabWith:(NSInteger)index {
  if (index < _tabBarItems.count && index >= 0) {
    _selectedIndex = index;
    for (UIView *tabView in _tabBarItems) {
      UIView *selectedLine = [tabView viewWithTag:LINE_VIEW_TAG];
      UILabel *titleLabel = (UILabel *)[tabView viewWithTag:TITLE_VIEW_TAG];
      if ([_tabBarItems indexOfObject:tabView] != _selectedIndex) {
        selectedLine.hidden = YES;
        titleLabel.textColor = [UIColor colorWithHexString:@"#2D3F58"];
      } else {
        selectedLine.hidden = NO;
        titleLabel.textColor = [UIColor colorWithHexString:@"#16C5BB"];
      }
    }
  }
}

/*
 当手动点击tab后，出发代理事件
 */
- (void)onTabTaped:(UIGestureRecognizer*)gestureRecognizer {
  UIView *tabView = gestureRecognizer.view;
  if (_tabDelegate) {
    [_tabDelegate onTabItemIndex:[_tabBarItems indexOfObject:tabView]];
  }
}

@end
