//
//  NetworkManager.h
//  网易新闻
//
//  Created by King on 2017/6/10.
//  Copyright © 2017年 King. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetworkManager : AFHTTPSessionManager
//单例对象的全局访问点
+ (instancetype)sharedManager;

/**
    获取数据主方法
     
 @param URLString 请求地址
 @param parameters 请求参数
 @param successBlock 成功回调,回调responseObject
 @param failureBlock 失败回调,回调error
*/
- (void)GETWithURLString:(NSString *)URLString parameters:(id)parameters success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;
    
@end
