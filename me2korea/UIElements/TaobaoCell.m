//
//  TaobaoCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/4.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "TaobaoCell.h"

@implementation TaobaoCell

- (void)configCellWithRecord:(Taobao *)record withType:(NSString *)type {
  self.textProductName.text = record.name;
  [self.textProductName setFont:[UIFont systemFontOfSize:15.0]];
  self.labelPrice.text = [NSString stringWithFormat:@"￥%@", record.price];
  self.labelSoldCount.text = record.saleCount.stringValue;
  self.labelCommentsCount.text = record.commentCount.stringValue;
  [self.thumImage sd_setImageWithURL:[NSURL URLWithString:record.imgSrc] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
  
  if (record.saleCount.integerValue < 0 || record.commentCount.integerValue < 0) {
    self.bottomSpace1.constant = -20;
    self.bottomSpace2.constant = -20;
    self.bottomSpace3.constant = -20;
    self.bottomSpace4.constant = -20;
  }
}

@end
