//
//  TVDetailViewController.m
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/11.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#import "TVDetailViewController.h"
#import "CustomNavigationBar.h"
#import "PlayLinkCell.h"

#define PLAYLINK_CELL_REUSE_TAG @"playlink_cell_nib"

@interface TVDetailViewController ()

@property (nonatomic, strong) Teleplay *record;
@property (nonatomic) NSInteger tvCount;
@property (weak, nonatomic) IBOutlet UIScrollView *pagerScrollView;
@property (weak, nonatomic) IBOutlet CustomNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *anchorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInfoViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;

@property (weak, nonatomic) IBOutlet UIImageView *thumImage;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDirector;
@property (weak, nonatomic) IBOutlet UILabel *labelActor;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelStation;
@property (weak, nonatomic) IBOutlet UILabel *labelShowTime;
@property (weak, nonatomic) IBOutlet UITextView *textTVDetailInfo;
@property (weak, nonatomic) IBOutlet UIView *playInfoView;
@property (weak, nonatomic) IBOutlet UICollectionView *playListView;
@property (strong, nonatomic) NSDictionary *playLinks;
@property (strong, nonatomic) NSArray *playLinkKeys;

- (IBAction)expandTextAreaView:(id)sender;

@end

@implementation TVDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRecord:(Teleplay *)record {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.record = record;
    self.tvCount = record.totalCount.integerValue;
    
    // 过滤不能播放的链接
    NSMutableDictionary *playLinks = [NSMutableDictionary dictionary];
    for (NSString *key in ((NSDictionary *)self.record.playLinks).allKeys) {
      NSString *link = [(NSDictionary *)self.record.playLinks objectForKey:key];
      if ([link rangeOfString:@"http"].length > 0) {
        NSString *title = key;
        if (key.length >= 8) {
          title = [key substringToIndex:8];
        }
        [playLinks setObject:link forKey:title];
      }
    }
    self.playLinks = playLinks;
    
    // 为综艺节目按照标题排序
    self.playLinkKeys = self.playLinks.allKeys;
    if ([self.record.type isEqualToString:@"entertainment"]) {
      self.playLinkKeys = [self.playLinkKeys sortedArrayUsingFunction:playLinkSort context:nil];
    }
  }
  
  return self;
}

NSInteger playLinkSort(id item1, id item2, void *reverse) {
  NSString *title1 = (NSString *)item1;
  NSString *title2 = (NSString *)item2;
  
  if (title1.length >= 8) {
    title1 = [title1 substringToIndex:8];
  }
  if (title2.length >= 8) {
    title2 = [title2 substringToIndex:8];
  }
  
  if (title1.integerValue > title2.integerValue) {
    return NSOrderedAscending;
  } else {
    return NSOrderedDescending;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化基本信息
  [self.thumImage sd_setImageWithURL:[NSURL URLWithString:self.record.imgSrc] placeholderImage:[UIImage imageNamed:@"music_blue_bg"]];
  self.labelName.text = [NSString stringWithFormat:@"名字：%@", self.record.titleCn];
  self.labelDirector.text = [NSString stringWithFormat:@"导演：%@", self.record.director];
  self.labelActor.text = [NSString stringWithFormat:@"演员：%@", self.record.actor];
  self.labelAuthor.text = [NSString stringWithFormat:@"编剧：%@", self.record.writer];
  if ([self.record.type caseInsensitiveCompare:@"TV"] == NSOrderedSame) {
    self.labelCount.text = [NSString stringWithFormat:@"集数：%@", self.record.totalCount];
  } else {
    self.labelCount.text = [NSString stringWithFormat:@"集数：%lu", (unsigned long)[self.playLinkKeys count]];
  }
  self.labelStation.text = [NSString stringWithFormat:@"电视台：%@", self.record.tvStation];
  self.labelShowTime.text = [NSString stringWithFormat:@"首映时间：%@", self.record.firstTime];
  
  self.navigationBar.btnBack.hidden = NO;
  self.navigationBar.btnMenu.hidden = YES;
  [self.navigationBar.btnBack addTarget:self action:@selector(onTapBtnBack:) forControlEvents:UIControlEventTouchUpInside];
  [self.playListView registerNib:[UINib nibWithNibName:@"PlayLinkCell" bundle:nil] forCellWithReuseIdentifier:PLAYLINK_CELL_REUSE_TAG];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  // 设置剧情介绍的文字字体和行距
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = TV_INFO_LINE_SPACE;// 字体的行间距
  NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:TV_INFO_FONT_SIZE],
                               NSParagraphStyleAttributeName:paragraphStyle};
  self.textTVDetailInfo.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"剧情介绍：\r\n%@", self.record.info] attributes:attributes];
}

- (IBAction)expandTextAreaView:(id)sender {
  // 控制文字自适应高度
  [self.textTVDetailInfo sizeToFit];
  CGRect frame = self.textTVDetailInfo.frame;
  self.textInfoViewHeight.constant = frame.size.height;
  
  CGRect playInfoFrame = self.playInfoView.frame;
  playInfoFrame.origin.y = frame.origin.y + frame.size.height;
  playInfoFrame.size.height = playInfoFrame.size.width * 0.78;
  
  // 设置滚动区域高度
  self.anchorViewHeight.constant = playInfoFrame.origin.y + playInfoFrame.size.height;
  self.btnExpand.hidden = YES;
}

#pragma mark - CollectionView Delegate Methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PlayLinkCell *cell = [self.playListView dequeueReusableCellWithReuseIdentifier:PLAYLINK_CELL_REUSE_TAG forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PlayLinkCell" owner:self options:nil] objectAtIndex:0];
  }
  NSString *playNumber = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
  NSString *key = [self.playLinkKeys objectAtIndex:indexPath.row];
  NSString *playLink = [self.record.type isEqualToString:@"tv"] ? [self.playLinks objectForKey:playNumber] : [self.playLinks objectForKey:key];
  if ([self.record.type isEqualToString:@"entertainment"]) {
    NSString *title = key;
    [cell configCellWith:title andPlanNumber:playNumber andLink:playLink andTVName:self.record.titleCn];
  } else {
    [cell configCellWith:playNumber andPlanNumber:playNumber andLink:playLink andTVName:self.record.titleCn];
  }
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  PlayLinkCell *cell = (PlayLinkCell *)[self.playListView cellForItemAtIndexPath:indexPath];
  
  if (cell.playLink.length <= 0) {
    [self toastMessage:@"该视频暂时无法播放"];
    return;
  }
  
  NSString *title = [self.record.type isEqualToString:@"tv"] ? [NSString stringWithFormat:@"%@ %@", cell.playName, cell.playNumber] : cell.playName;
  CustomWebViewController *webViewController = [[CustomWebViewController alloc] initWithNibName:@"CustomWebViewController" bundle:nil andUrl:cell.playLink andTitle:title andSupport:YES];
  [self presentViewController:webViewController animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.playLinks.allKeys.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = collectionView.frame.size.width / 5;
  return CGSizeMake(width, width * 0.79);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

#pragma - mark User Events
- (void)onTapBtnBack:(id) sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
