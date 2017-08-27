//
//  LatestMusicCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/8.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import "LatestMusicCell.h"

@implementation LatestMusicCell

- (void)configCellWithNews:(News *)record withType:(NSString *)type andIndex:(NSInteger)index {
  self.txtMusicTitle.text = record.title;
  self.txtMusicTitle.font = [UIFont systemFontOfSize:16.0];
  if (record.thumbLink.length > 0) {
    [self.imgMusic sd_setImageWithURL:[NSURL URLWithString:record.thumbLink] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
  }
  self.tipHotMusic.hidden = index > 2;
  
  // 设置剧本小说的专用样式
  if ([type isEqualToString:@"剧本小说"]) {
    self.tipHotMusic.hidden = YES;
    self.txtMusicTitle.font = [UIFont systemFontOfSize:14.0];
  }
}

@end
