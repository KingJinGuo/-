//
//  NewsDetailViewController.h
//  网易新闻
//
//  Created by King on 2017/6/11.
//  Copyright © 2017年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsDetailViewController : UIViewController

- (instancetype)initWithNewsModel:(NewsModel *)news;

@end
