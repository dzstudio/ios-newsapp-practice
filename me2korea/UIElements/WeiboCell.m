//
//  WeiboCell.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/10.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "WeiboCell.h"
#import "NSDate+String.h"

@interface WeiboCell()

@property (nonatomic, strong) Weibo *record;

@end

@implementation WeiboCell

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  [self.textContent sizeToFit];
  
  // 设置图片的位置
  if (self.record.thumbnail_pic.length > 0) {
    [self.thumImage sd_setImageWithURL:[NSURL URLWithString:self.record.thumbnail_pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
      if (!image) {
        return;
      }
      CGRect frame = self.thumImage.frame;
      frame.size.width = self.thumImage.image.size.width * (100 / self.thumImage.image.size.height);
      self.thumImage.frame = frame;
      self.thumImage.hidden = NO;
    }];
  } else {
    self.thumImage.hidden = YES;
  }
  
  // 设置皇冠图标的位置
  CGRect crownFrame = self.crownImage.frame;
  crownFrame.origin.x = self.labelAuthor.frame.origin.x + 5 + [self.record.screenName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}].width;
  self.crownImage.frame = crownFrame;
}

- (void)configCellWithRecord:(Weibo *)record {
  self.record = record;
  self.textContent.text = record.text;
  self.textContent.font = [UIFont systemFontOfSize:WEIBO_CONTENT_FONT_SIZE];
  [self.profileImage sd_setImageWithURL:[NSURL URLWithString:record.profileImageUrl]];
  self.labelAuthor.text = record.screenName;
  self.labelPlatform.text = record.sourceName;
  self.labelCreatedTime.text = [record.created_at weiboStyle];
  self.labelForward.text = record.reposts_count.stringValue;
  self.labelComment.text = record.comments_count.stringValue;
  self.labelHit.text = record.attitudes_count.stringValue;
  [self drawRect:self.frame];
}

@end
