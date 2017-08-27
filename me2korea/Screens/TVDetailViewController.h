//
//  TVDetailViewController.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/11.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVDetailViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecord:(Teleplay *)record;

@end
