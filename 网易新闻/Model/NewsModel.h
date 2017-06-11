//
//  NewsModel.h
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
///标题
@property (nonatomic, copy) NSString *title;
///图片
@property (nonatomic, copy) NSString *imgsrc;
///来源
@property (nonatomic, copy) NSString *source;
///回复数
@property (nonatomic, strong) NSNumber *replyCount;
/// 多张配图
@property (nonatomic, strong) NSArray *imgextra;
/// 大图标记
@property (nonatomic, assign) BOOL imgType;
/// 新闻详情文档标识
@property (nonatomic,copy) NSString *docid;


@end


/*
 {
 "postid": "CMICF6IN000181KT",
 "url_3w": "http://news.163.com/17/0610/08/CMICF6IN000181KT.html",
 "votecount": 1323,
 "replyCount": 1524,
 "pixel": "1000*541",
 "ltitle": "日本一架国产C2运输机起飞前失控冲出跑道",
 "digest": "【环球网军事6月10日报道】俄罗斯卫星通讯社东京6月9日电日本广播协会(NHK)报道称，该国航空自卫队一架川崎-C2(KawasakiC-2)军用运输机在米子美",
 "url": "http://3g.163.com/news/17/0610/08/CMICF6IN000181KT.html",
 "docid": "CMICF6IN000181KT",
 "title": "日本一架国产C2运输机起飞前失控冲出跑道",
 "source": "环球时报-环球网",
 "priority": 88,
 "lmodify": "2017-06-10 12:32:38",
 "boardid": "news_junshi_bbs",
 "imgsrc": "http://cms-bucket.nosdn.127.net/catchpic/c/cf/cff1d7637772a0326def287d73509016.jpg",
 "subtitle": "",
 "ptime": "2017-06-10 08:57:21"
 }
 */
