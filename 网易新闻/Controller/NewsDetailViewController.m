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

@interface NewsDetailViewController ()<UIWebViewDelegate,ESPictureBrowserDelegate>

@end

@implementation NewsDetailViewController {
    
    NewsModel *_news;
    UIWebView *_webView;
    NSMutableArray *_imageUrls;
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
    
    _imageUrls = [NSMutableArray array];
    
    //创建 UIwebView
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    webView.opaque = NO;
    webView.backgroundColor = [UIColor whiteColor];
    
    //接受数据
    _webView = webView;
    //设置代理
    _webView.delegate =self;
    
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        
        NSLog(@"%@",result);
        
        
        //获取 body 展示 HTML 的数据
        NSString *html = result[@"body"];
        //获取 图片
        NSArray *imgs = result[@"img"];
        
        //遍历 imgs 取出里面的ref(标签) 和 src(图片的地址), 替换 body 中的<!--IMG#0-->
        for (NSDictionary *imgDict in imgs) {
            //取出 ref
            NSString *ref = imgDict[@"ref"];
            //拿着 ref 去 body 中找<!--IMG#0-->
            NSRange range = [html rangeOfString:ref];
            
            //如果找到 先拼接 img 的标签
            NSString *imgTag = [NSString stringWithFormat:@"<img src = \"%@\" />",imgDict[@"src"]];
            // 使用 imgTag 替换 body 中的<!--IMG#0-->
            html = [html stringByReplacingCharactersInRange:range withString:imgTag];
            
            // 把遍历出来的图片地址保存起来，展示图片查看器时要用
            [_imageUrls addObject:imgDict[@"src"]];
        }
        //把 CSS 样式拼接到HTML 中
        NSString *CSSPath = [[NSBundle mainBundle] pathForResource:@"newsDetail.css" ofType:nil];
        NSString *CSSStr = [NSString stringWithContentsOfFile:CSSPath encoding:NSUTF8StringEncoding error:NULL];
        
        //带有 CSS 样式的 HTML
        html = [html stringByAppendingString:CSSStr];
        
        // webview 加载 HTML
        [_webView loadHTMLString:html baseURL:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *jsString =
    @"function setImage(){\
    var imgs = document.getElementsByTagName('img');\
    for (var i=0;i<imgs.length;i++){\
    imgs[i].setAttribute(\"onClick\",\"imageClick(\"+i+\")\");\
    }\
    }\
    function imageClick(i){\
    var rect = getImageRect(i);\
    var url = \"imagetagclick::\"+i+\"::\"+rect;\
    document.location = url;\
    }\
    function getImageRect(i){\
    var imgs = document.getElementsByTagName(\"img\");\
    var rect;\
    rect = imgs[i].getBoundingClientRect().left+\"::\";\
    rect = rect+imgs[i].getBoundingClientRect().top+\"::\";\
    rect = rect+imgs[i].width+\"::\";\
    rect = rect+imgs[i].height;\
    return rect;\
    }";
    
    //注入 需要的 JS
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    
    //执行方法
    [webView stringByEvaluatingJavaScriptFromString:@"setImage()"];
    
}


// 在这个方法中捕获到图片的点击事件和被点击图片的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //浏览图片
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@"::"];
    NSLog(@"%@",components);
    if ([[components firstObject] isEqualToString:@"imagetagclick"]) {
        
        //标记从第几个开始
        NSInteger index = [components[1] integerValue];
        CGFloat X = [components[2] floatValue];
        CGFloat Y = [components[3] floatValue];
        CGFloat W = [components[4] floatValue];
        CGFloat H = [components[5] floatValue];
        
        //参照控件
        UIView *Cview = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        [webView addSubview:Cview];
        
        //图片查看器的  第三方框架
        ESPictureBrowser *browser = [ESPictureBrowser new];
        browser.delegate = self;
        
        [browser showFromView:Cview picturesCount:_imageUrls.count currentPictureIndex:index];
        //点击后删除
        [Cview removeFromSuperview];
        return NO;
    }
    
    return YES;
    
}


#pragma mark - 图片查看器的代理
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getImageRect(%ld)",index]];
    
    NSArray *components = [result componentsSeparatedByString:@"::"];
    
    CGFloat X = [components[0] floatValue];
    //因为有 64 的导航栏
    CGFloat Y = [components[1] floatValue] + 64;
    CGFloat W = [components[2] floatValue];
    CGFloat H = [components[3] floatValue];
    
    UIView *Cview = [[UIView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    
    return Cview;
}


- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    
    return _imageUrls[index];
}


- (void)pictureView:(ESPictureBrowser *)pictureBrowser scrollToIndex:(NSInteger)index {
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getImageRect(%ld)",index]];
    
    NSArray *components = [result componentsSeparatedByString:@"::"];
    CGFloat y = [components[1] floatValue];
    CGPoint contentOffset = _webView.scrollView.contentOffset;
    [_webView.scrollView setContentOffset:CGPointMake(0, y + contentOffset.y)];
}

@end
