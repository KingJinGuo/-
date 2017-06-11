//
//  NetworkManager.m
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (instancetype)sharedManager {
    
    static NetworkManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //子类调用父类的实例化方法
        NSURL *baseURL = [NSURL URLWithString:@"http://c.m.163.com/"];
        instance = [[self alloc] initWithBaseURL:baseURL];
        
        //增加 afn 文件支持的文件类型
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
    });
    
    return instance;
}

- (void)GETWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock {
    [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // Block回调时,必须判断是否为空.一旦为空,如果强制调用,就会空指针访问
        if (successBlock != nil) {
            // 把AFN拿到的responseObject,通过VC传入的代码块,回调给VC
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (successBlock != nil) {
            successBlock(error);
        }
    }];
}

    
    
    
    
@end
