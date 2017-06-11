//
//  NewsTableViewCell.m
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import "NewsTableViewCell.h"
#import <UIImageView+WebCache.h>


@interface NewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *replaycountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgsrcImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@implementation NewsTableViewCell

- (void)setNews:(NewsModel *)news {
    
    _news =news;
    
    self.titleLabel.text = news.title;
    self.sourceLabel.text = news.source;
    self.replaycountLabel.text = news.replyCount.stringValue;
    
    //下载基本样式的图片
    [self.imgsrcImageView sd_setImageWithURL:[NSURL URLWithString:news.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    if (news.imgextra.count > 0) {
        // 遍历出控件和对应的图片地址
        for (NSInteger i = 0; i < self.imageViews.count; i++) {
            
            // 取控件
            UIImageView *imgView = self.imageViews[i];
            
            // 取图片地址
            NSDictionary *imgsrcDict = news.imgextra[i];
            NSString *imgsrc = imgsrcDict[@"imgsrc"];
            
            // 下载图片
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgsrc] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
    
    
    
}

@end
