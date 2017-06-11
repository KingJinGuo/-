//
//  NewsDetailViewController.m
//  网易新闻
//
//  Created by King on 2017/6/11.
//  Copyright © 2017年 King. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NetworkManager.h"
#import <ESPictureBrowser.h>

@interface NewsDetailViewController ()<UIWebViewDelegate>

@end

@implementation NewsDetailViewController {
    
    NewsModel *_news;
    UIWebView *_webView;
}

- (instancetype)initWithNewsModel:(NewsModel *)news {
    self = [super init];
    if (self) {
        _news = news;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建 UIwebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //接受数据
    _webView = webView;
    //设置代理
    _webView.delegate =self;
    
    [self.view addSubview:webView];
    
    [self loadNewsDetailData];
}

#pragma mark - 加载数据
- (void)loadNewsDetailData {
    
    
    //请求地址 :URL   http://c.m.163.com/nc/article/CMKR5T2A000181KT/full.html
    NSString *URLString = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",_news.docid];
    
    [[NetworkManager sharedManager] GETWithURLString:URLString parameters:nil success:^(id responseObject) {
        
        //获取字典
        NSDictionary *result = responseObject[_news.docid];
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}









@end
