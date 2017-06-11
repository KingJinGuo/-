//
//  SliderView.m
//  网易新闻
//
//  Created by King on 2017/6/11.
//  Copyright © 2017年 King. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor purpleColor];
        
        // 添加到父视图window(需要盖住导航)
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        // 设置frame
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        self.frame = CGRectMake(-screenW, 0, screenW, screenH);
        
        // 轻扫手势
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
        // 设置轻扫方向 : 向左滑
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipe];
    }
    
    return self;
}

/// 实现轻扫手势 - 还原(从右到左滑动)
- (void)swipeGestureAction:(UISwipeGestureRecognizer *)swipe {
    //设置 拖拽时的动画
    [UIView animateWithDuration:0.25 animations:^{
        //设置view 当前的位置
        self.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
}

@end
