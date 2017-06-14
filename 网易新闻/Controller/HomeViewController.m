//
//  ViewController.m
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkManager.h"
#import "NewsModel.h"
#import <YYModel.h>
#import "NewsTableViewCell.h"
#import "SliderView.h"
#import "NewsDetailViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
///数据源方法
@property (nonatomic, strong) NSArray *newsList;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end

@implementation HomeViewController {
    SliderView *_slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加列表
    [self setupTableView];
    //添加数据
    [self loadData];
    //添加广告 滑块
    [self createSliderView];
}

#pragma mark - 创建广告滑块
- (void)createSliderView {
    
    // 创建
    SliderView *slider = [SliderView new];
    _slider = slider;
    
    // 添加屏幕边缘滑动手势
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanGestureAction:)];
    // 添加手势
    [self.view addGestureRecognizer:panGesture];
    // 设置滑动方向 : 从左往右滑
    panGesture.edges = UIRectEdgeLeft;
    // 列表禁用该手势
    [self.newsTableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
}

/// 频幕边缘滑动手势事件
- (void)screenEdgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)panGesture {
    
    // 获取实时滑动的点
    CGPoint offsetPoint = [panGesture translationInView:panGesture.view];
    // 归零偏移量 : CGAffineTransformTranslate会累加
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            // 滑块实时滚动 : 横向移动
            _slider.transform = CGAffineTransformTranslate(_slider.transform, offsetPoint.x, 0);
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGFloat sliderX;
            
            // 获取当前滑块最大的x值 : 如果maxX > screenW * 0.75(全屏)     否则 还原
            CGFloat maxX = CGRectGetMaxX(_slider.frame);
            if (maxX > [UIScreen mainScreen].bounds.size.width * 0.75) {
                sliderX = 0;
            } else {
                sliderX = -[UIScreen mainScreen].bounds.size.width;
            }
            
            //改变 frame 的值
            [UIView animateWithDuration:0.25 animations:^{
                _slider.frame = CGRectMake(sliderX, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 设置列表
- (void)setupTableView {
    // iOS7.0的新特性,当滚动视图(UIWebView,UITableView,UICollectionView,UIScrollView,UITextView...)自动布局时如果遇到导航,里面的内容会自动向下偏移64像素
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //注册 cell
    [self.newsTableView registerNib:[UINib nibWithNibName:@"BaseCell" bundle:nil] forCellReuseIdentifier:@"BaseCell"];
    [self.newsTableView registerNib:[UINib nibWithNibName:@"BigCell" bundle:nil] forCellReuseIdentifier:@"BigCell"];
    [self.newsTableView registerNib:[UINib nibWithNibName:@"imagesCell" bundle:nil] forCellReuseIdentifier:@"imagesCell"];
    
    //遵守数据源
    self.newsTableView.dataSource =self;
    self.newsTableView.delegate = self;
    
}


- (void)loadData {
    
    //URL
    NSString *URLString = @"nc/article/list/T1348648141035/0-20.html";
    
    [[NetworkManager sharedManager] GETWithURLString:URLString parameters:nil success:^(NSDictionary *responseObject) {
        
        //获取字典的 key
        NSString *key = responseObject.keyEnumerator.nextObject;
        //获取字典数组
        NSArray *dictArr = responseObject[key];
        
        //YYModel 实现JSON 转模型
        self.newsList = [NSArray yy_modelArrayWithClass:[NewsModel class] json:dictArr];
        
        //赋值后刷新列表
        [self.newsTableView reloadData];
        
        NSLog(@"%@",self.newsList);
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
}



#pragma mark - 设置 cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取 cell的模型数据
    NewsModel *news = self.newsList[indexPath.row];

    // 再根据模型数据选择对应的演示/标识 (cell的样式和模型数据的绑定)
    NSString *identifier;
    if (news.imgType == YES) {
        identifier = @"BigCell";
    }else if (news.imgextra.count > 0) {
        identifier = @"imagesCell";
    }else {
        identifier =@"BaseCell";
    }
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    //把对应的行的模型传递给 cell
    cell.news = news;
    
    return cell;
    
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取 cell的模型数据
    NewsModel *news = self.newsList[indexPath.row];
    
    // 再根据模型数据选择对应的演示/标识 (cell的样式和模型数据的绑定)
    CGFloat cellH;
    if (news.imgType == YES) {
        cellH = 180;
    }else if (news.imgextra.count > 0) {
        cellH = 130;
    }else {
        cellH = 80;
    }
    
    return cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //设置 当前的选中cell 的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取点击 cell 的对应的模型
    NewsModel *news = _newsList[indexPath.row];
    
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] initWithNewsModel:news];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

@end
