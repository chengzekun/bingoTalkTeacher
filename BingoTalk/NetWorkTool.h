//
//  NetWorkTool.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface NetWorkTool : AFHTTPSessionManager

+ (instancetype)sharedInstance;

+ (BOOL)isNetWorkReachable;

+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)POSTAction:(NSString *)LoginAction
      formDataParameter:(NSDictionary *)parameter
      progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
      errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)GETAction:(NSString *)action
         setCache:(BOOL)setCache
   readCacheFirst:(BOOL) readCacheFirst
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)GETAction:(NSString *)action
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *errorDesc))errorBlock;

+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
            images:(NSArray *)images
     progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock;

@end

@interface BTNetCacheTool : NSObject

+ (id)getJSONCacheWithURL:(NSString *)url  parameter:(NSDictionary *)parameter;

+ (void)setJSONCacheWithURL:(NSString *)url parameter:(NSDictionary *)parameter cacheDict:(id )data;

+ (void)deleteCache;

+ (NSString *)sizeOfCache;

+ (NSUInteger)sizeOfCacheWithoutUnit;
@end
