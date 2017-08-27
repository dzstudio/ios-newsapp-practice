//
//  MediaPagerView.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "BasePagerView.h"

@interface MediaPagerView : BasePagerView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *isEnd;
@property (nonatomic, strong) UICollectionView *collectionView;
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type andEnd:(NSString *)isend;

@end
