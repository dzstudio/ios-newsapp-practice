//
//  VideoCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/5.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

- (void)configCellWithRecord:(Video *)record {
  self.labelTitle.text = record.title;
  self.labelPlayer.text = record.author;
  self.labelPlayCount.text = record.playCount.stringValue;
  self.labelUpdateDate.text = record.createTime;
  [self.thumImage sd_setImageWithURL:[NSURL URLWithString:record.imgSrc] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
}

@end
