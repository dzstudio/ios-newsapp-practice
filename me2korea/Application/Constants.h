//
//  Constants.h
//  ios-newsapp-practice
//
//  Created by DillonZhang on 15/6/11.
//  Copyright (c) 2015年 dillonzhang. All rights reserved.
//

#define M2AppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define Preferences ((M2Preferences *)[M2AppDelegate preferences])
// (lldb) po (AppDelegate *)[[UIApplication sharedApplication] delegate] ---> <AppDelegate: 0x7fc4c9f01d70>
// (lldb) po ((M2Preferences *)[(AppDelegate *)[[UIApplication sharedApplication] delegate] preferences]).hideVideos.boolValue ---> NO
// expr ((M2Preferences *)[(AppDelegate *)[[UIApplication sharedApplication] delegate] preferences]).hideVideos=[NSNumber numberWithBool:YES]

#define SYSTEM_VERSION_COMPARE(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch])

#define SYSTEM_VERSION_LESS_THAN(v) \
(SYSTEM_VERSION_COMPARE(v) == NSOrderedAscending)

#define GAP_HOUR @"hour"
#define GAP_DAY @"day"
#define GAP_WEEK @"week"

// API数据类型
#define TAOSTORE_HANLIU         @"hanliu"
#define TAOSTORE_ZHOUBIAN       @"zhoubian"
#define TAOTYPE_LATEST          @"Latest"
#define TAOTYPE_FAV             @"Favorate"
#define TAOTYPE_SUGGEST         @"Suggest"
#define NEWS_DRESS              @"时尚服饰"
#define NEWS_BEAUTIFIER         @"美容美妆"
#define NEWS_ENTERTAIN          @"花絮八卦"
#define NEWS_STARS              @"明星专访"
#define NEWS_FARMS              @"动物农场"

#define TOPTENSID_WEEK   @"每周音源舞台总结"
#define TOPTENSID_LATEST   @"最新热门专辑"
#define TOPTENSID_HANTEO_REAL   @"hanteo_real"
#define TOPTENSID_HANTEO_DAY    @"hanteo_day"
#define TOPTENSID_MNET          @"mnet"
#define TOPTENSID_MELON         @"melon"
#define TOPTENSID_BUGS          @"bugs"
#define TOPTENSID_NEVER         @"naver"
#define TOPTENSID_DAUM          @"daum"

#define VIDEOTYPE_TUDOU         @"tudou"

#define MEDIATYPE_TV            @"tv"
#define MEDIATYPE_ENTERTAINMENT @"entertainment"

// UI配置
#define WEIBO_CONTENT_FONT_SIZE 16.0
#define NOVEL_DESC_FONT_SIZE 14.0
#define TV_INFO_FONT_SIZE 15.0
#define TV_INFO_LINE_SPACE 3.0

// 微博配置
#define WEIBO_APPKEY        @"1013234856"
#define WEIBO_DOMAIN_URL    @"https://api.weibo.com"
#define WEIBO_REDIRECT_URI  @"https://api.weibo.com/oauth2/default.html"
#define WEIBO_GO_URL        @"http://api.weibo.com/2/statuses/go"
#define DZ_UID        @"2482523215"
#define WEIBO_SCOPE @"email, direct_messages_read, direct_messages_write, friendships_groups_read, friendships_groups_write, statuses_to_me_read, follow_app_official_microblog, invitation_write";

#endif

@interface Constants : NSObject

+ (NSDictionary *)siteIdMap;
+ (NSArray *)autoRefreshPagers;

@end
