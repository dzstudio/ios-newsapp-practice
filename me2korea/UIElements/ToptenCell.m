//
//  ToptenCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/5/31.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "ToptenCell.h"

@implementation ToptenCell

- (void)configCellWithRecord:(Toptenz *)record withType:(NSString *)type {
  
  self.labelRank.text = record.rank.stringValue;
  self.labelTitle.text = [self getDisplayTitle:record withType:type];
  self.labelArtist.text = [self getDisplayArtist:record withType:type];
  if (record.avatar.length > 0) {
    [self.thumImage sd_setImageWithURL:[NSURL URLWithString:record.avatar] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
  }
  
  if ([type isEqualToString:@"hanteo_day"] || [type isEqualToString:@"hanteo_real"]) {
    self.tipIcon.image = [UIImage imageNamed:@"tabbar_mall"];
  }
  self.tipIcon.hidden = (record.extern_link.length <= 0);
  
  if (record.rank.intValue <= 3) {
    self.budgetIcon.hidden = NO;
    self.labelRank.font = [UIFont systemFontOfSize:12.0];
    self.labelRank.textColor = [UIColor colorWithHexString:@"#FEFFFF"];
  } else {
    self.budgetIcon.hidden = YES;
    self.labelRank.font = [UIFont systemFontOfSize:10.0];
    self.labelRank.textColor = [UIColor colorWithHexString:@"#00CABE"];
  }
}

/*
 通过数据取出显示标题
 */
- (NSString *)getDisplayTitle:(Toptenz *)record withType:(NSString *)type {
  if ([type isEqualToString:@"hanteo_day"]) {
    return record.album;
  } else if ([type isEqualToString:@"hanteo_real"]) {
    return record.album;
  } else if ([type isEqualToString:@"mnet"]) {
    return record.title;
  } else if ([type isEqualToString:@"melon"]) {
    return record.title;
  } else if ([type isEqualToString:@"bugs"]) {
    return record.title;
  } else if ([type isEqualToString:@"naver"]) {
    return record.title;
  } else if ([type isEqualToString:@"daum"]) {
    return record.title;
  } else {
    return record.album;
  }
}

/*
 通过数据取出显示歌手
 */
- (NSString *)getDisplayArtist:(Toptenz *)record withType:(NSString *)type {
  if ([type isEqualToString:@"hanteo_day"]) {
    return [NSString stringWithFormat:@"销量：%@", record.title];
  } else if ([type isEqualToString:@"hanteo_real"]) {
    return [NSString stringWithFormat:@"销量：%@", record.title];
  } else if ([type isEqualToString:@"mnet"]) {
    return record.artist;
  } else if ([type isEqualToString:@"melon"]) {
    return record.artist;
  } else if ([type isEqualToString:@"bugs"]) {
    return record.artist;
  } else if ([type isEqualToString:@"naver"]) {
    return record.artist;
  } else if ([type isEqualToString:@"daum"]) {
    return record.artist;
  } else {
    return record.artist;
  }
}

@end
