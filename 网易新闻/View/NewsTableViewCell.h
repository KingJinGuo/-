//
//  NewsTableViewCell.h
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsTableViewCell : UITableViewCell

/// 接收VC传入的模型数据
@property (nonatomic, strong) NewsModel *news;

@end
