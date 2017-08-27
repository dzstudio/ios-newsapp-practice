//
//  MediaCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "MediaCell.h"

@implementation MediaCell

- (void)configCellWithRecord:(Teleplay *)record {
  self.labelMediaTitle.text = record.titleCn;
  if ([record.is_end isEqualToString:@"yes"]) {
    self.labelUpdateInfo.text = [NSString stringWithFormat:@"%d集全", [record.totalCount intValue]];
  } else {
    NSUInteger playCount = [((NSDictionary *)record.playLinks) count];
    self.labelUpdateInfo.text = [NSString stringWithFormat:@"更新至第%lu集", (unsigned long)playCount];
    //self.labelUpdateInfo.text = [NSString stringWithFormat:@"更新至第%d集",[record.totalCount intValue]];
  }
  if ([record.type isEqualToString:@"entertainment"]) {
    self.tipView.hidden = YES;
  }
  [self.thumImage sd_setImageWithURL:[NSURL URLWithString:record.imgSrc] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
}

@end
