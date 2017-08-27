//
//  NovelPagerView.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/12/11.
//  Copyright © 2015年 dillonzhang. All rights reserved.
//

#import "NovelPagerView.h"
#import "Utils.h"

#define DESC_VIEW_DEFAULT_HEIGHT 120.0

@implementation NovelPagerView

- (void)awakeFromNib {
  [super awakeFromNib];
  [[APIProcessor instance] loadNovelsWithTitle:@"以法之名相爱" andTime:self.lastLoadTime andSuccess:^(NSDictionary *res){
    if (![res isMemberOfClass:[NSNull class]]) {
      // 读取小说信息
      Novel *novel = [Novel MR_findFirstByAttribute:@"title" withValue:@"以法之名相爱"];
      if (novel) {
        [self performSelectorOnMainThread:@selector(renderNovelInfo:) withObject:novel waitUntilDone:YES];
      }
    }
  } andFailure:^(NSError *error){}];
}

- (void)initPageFrame:(CGRect)frame andTitle:(NSString *)title andType:(NSString *)type {
  self.type = type;
  self.title = title;
  self.frame = frame;
  self.isNewsType = ([type isEqualToString:TOPTENSID_WEEK]
                     || [type isEqualToString:TOPTENSID_LATEST]
                     || [type isEqualToString:NEWS_DRESS]
                     || [type isEqualToString:NEWS_BEAUTIFIER]
                     || [type isEqualToString:NEWS_ENTERTAIN]
                     || [type isEqualToString:NEWS_STARS]
                     || [type isEqualToString:NEWS_FARMS]);
  NSError *error;
  [self.fetchedResultsController performFetch:&error];
  self.tableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, self.tableViewArea.frame.size} style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.tableViewArea addSubview:self.tableView];
  self.novelDescriptionView.font = [UIFont systemFontOfSize:NOVEL_DESC_FONT_SIZE];
  [[Utils instance] fillParentConstraintsFrom:self.tableView To:self.tableViewArea];
  self.anchorViewheight.constant = frame.size.height;
  [self layoutSubviews];
  
  //注册下拉刷新功能
  __weak BasePagerView *weakself = self;
  [self.tableView addPullToRefreshWithActionHandler:^{
    [weakself refreshLatestData];
  }];
  
  //注册上拉加载功能
  [self.tableView addInfiniteScrollingWithActionHandler:^{
    [weakself loadMoreData];
  }];
  
  self.tableView.pullToRefreshView.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"下拉刷新...",),
                                             NSLocalizedString(@"松开以更新...",),
                                             NSLocalizedString(@"正在更新...",),
                                             nil];
  
}

/*
 展示小说信息
 */
- (void)renderNovelInfo:(Novel *)novel {
/*
  self.novelTitle.text = novel.title;
  self.novelAuthor.text = [NSString stringWithFormat:@"<%@> (原著：%@)", novel.title, novel.author];
  self.novelDescriptionView.text = novel.novel_desc;
 */
  // Hard Code写入小说信息
  self.novelTitle.text = novel.title;
  self.novelAuthor.text = @"<以法之名相爱>（原著作者：鲁胜雅）";
  self.novelDescriptionView.text = @"友莉小时候，父亲因为医疗事故丧生，倾家荡产去打官司却只得落败，友莉一家彻底输给了金钱和权利。在这之后，友莉便一门心思的用功读书。社区有一家友莉认识的律师开的咖啡厅。只是去买豆腐的途中走进去，却可以像聊天一样询问自己想知道的事情的地方便是这家Law Cafe。这样的咖啡厅是友莉自幼时起的梦想，为此她放弃了大型律师事务所，勒紧裤腰带，用攒下的钱在母校附近找到了一处适合开咖啡厅的地方——位于大学后门，能够沐浴在樱花雨之中的娴静之处。友莉对这座建筑很满意，更何况楼上的屋塔房里还住着她的14年知己正浩。虽然两个人就像汤姆和杰瑞一样的欢喜冤家，但也是可以依靠的对象，正浩也住在这里让友莉感到更加满意。来签最终协议的时候，看到了乱蓬蓬的头发之下那张陌生的脸。正浩十分尊敬并相信其清廉作风的父亲，因为受贿这种有损名誉的事情而从检察长的位置上退了下来。更何况这次受贿还与自己深爱了14年的友莉有关。在对父亲的失望和类似负罪感的折磨下，正浩放弃了检察官的大好前程，画过几篇网络漫画，彻底垮掉、变成留着乱篷篷的头发和胡须还穿着土到极点的运动服的模样已是第三年了。肚子饿了就出门到附近的商家讨饭吃，困了就睡，想看电影了就看，彻底向法律界say goodbye，对存在诸多不足的自己来说只能是奢望一般存在的友莉，却突然出现在自己居住的地方并要开一家法律咨询咖啡厅。友莉的店面就选在自己楼下，而且会每天见面。这可不行！绝对不行！“我爱你。没有爱你的资格的我却爱上了你，很抱歉。”在这个世态炎凉的世上生活下去的方法，绝非一般的、争取彼此的心意的方法，以及，我们怀着满腔热情生活、相爱的方法。";
  self.novelDescriptionView.font = [UIFont systemFontOfSize:NOVEL_DESC_FONT_SIZE];
  [self.novelPicture sd_setImageWithURL:[NSURL URLWithString:novel.picLink] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return ([UIScreen mainScreen].bounds.size.width / 320) * 66.0;
}

- (IBAction)onTapExpandBtn:(id)sender {
  if (self.descriptionViewHeight.constant == DESC_VIEW_DEFAULT_HEIGHT) {
    NSString *desc = [self.novelDescriptionView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    desc = [desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    CGSize fontSize = [desc sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:NOVEL_DESC_FONT_SIZE]}];
    CGFloat height = (fontSize.height + 5) * (fontSize.width / self.novelDescriptionView.frame.size.width);
    self.anchorViewheight.constant = self.frame.size.height + height - DESC_VIEW_DEFAULT_HEIGHT;
    self.descriptionViewHeight.constant = height;
    [self.btnExpand setTitle:@"收起" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
      [self layoutIfNeeded];
    }];
    
  } else {
    self.descriptionViewHeight.constant = DESC_VIEW_DEFAULT_HEIGHT;
    self.anchorViewheight.constant = self.frame.size.height;
    [self.btnExpand setTitle:@"展开" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
      [self layoutIfNeeded];
    }];
  }
}

@end
