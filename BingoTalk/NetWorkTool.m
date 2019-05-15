//
//  NetWorkTool.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//


#import "NetWorkTool.h"
#import "AFNetworkReachabilityManager.h"
#import "NSString+Hash.h"

@interface BTNetCacheTool()

@property (nonatomic, strong)NSMutableDictionary  *chacheKeySet;
@end

@implementation BTNetCacheTool

+ (instancetype)sharedInstance {
    static BTNetCacheTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [BTNetCacheTool new];
        NSMutableDictionary *keySet = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"KEYS"]];
        if (keySet != nil) {
            tool.chacheKeySet = keySet;
        }
        else {
            tool.chacheKeySet = [NSMutableDictionary new];
        }
    });
    
    return tool;
}


+ (id)getJSONCacheWithURL:(NSString *)url  parameter:(NSDictionary *)parameter {
    NSMutableString *key = [url mutableCopy];
    if (parameter) {
        [parameter keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([obj2 isKindOfClass:[NSNumber class]] && ![obj1 isKindOfClass:[NSNumber class]]) {
                return [obj1 compare:[NSString stringWithFormat:@"%d",[obj2 intValue]] options:NSNumericSearch];
            }else if ([obj1 isKindOfClass:[NSNumber class]] && ![obj2 isKindOfClass:[NSNumber class]]) {
                return [[NSString stringWithFormat:@"%d",[obj1 intValue]] compare:obj2 options:NSNumericSearch];
            }else if([obj1 isKindOfClass:[NSNumber class]] && [obj2 isKindOfClass:[NSNumber class]]) {
                return [[NSString stringWithFormat:@"%d",[obj1 intValue]] compare:[NSString stringWithFormat:@"%d",[obj2 intValue]] options:NSNumericSearch];
            }
            return  [obj1 compare:obj2 options:NSNumericSearch];
        }];
        [key appendString:parameter.description];
    }
    NSString *hashOfKey = [key MD5Value];
    if ([[[self sharedInstance] chacheKeySet][hashOfKey]intValue] != 1) {
        return nil;
    }
    id cache = [[NSUserDefaults standardUserDefaults]objectForKey:hashOfKey];
    return cache;
}


+ (void)setJSONCacheWithURL:(NSString *)url parameter:(NSDictionary *)parameter cacheDict:(id )data {
    NSMutableString *key = [url mutableCopy];
    if (parameter) {
        [parameter keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj2 isKindOfClass:[NSNumber class]] && ![obj1 isKindOfClass:[NSNumber class]]) {
                return [obj1 compare:[NSString stringWithFormat:@"%d",[obj2 intValue]] options:NSNumericSearch];
            }else if ([obj1 isKindOfClass:[NSNumber class]] && ![obj2 isKindOfClass:[NSNumber class]]) {
                return [[NSString stringWithFormat:@"%d",[obj1 intValue]] compare:obj2 options:NSNumericSearch];
            }else if([obj1 isKindOfClass:[NSNumber class]] && [obj2 isKindOfClass:[NSNumber class]]) {
                return [[NSString stringWithFormat:@"%d",[obj1 intValue]] compare:[NSString stringWithFormat:@"%d",[obj2 intValue]] options:NSNumericSearch];
            }
            
            return  [obj1 compare:obj2 options:NSNumericSearch];
            
        }];
        
        [key appendString:parameter.description];
    }
    NSMutableDictionary *keySet = [[self sharedInstance] chacheKeySet];
    NSString *hashOfKey = [key MD5Value];
    keySet[hashOfKey] = @1;
    [[NSUserDefaults standardUserDefaults]setObject:keySet forKey:@"KEYS"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([data isKindOfClass:[NSMutableArray class]] || [data isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *codingArray = [NSMutableArray array];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:data];
        
        [array enumerateObjectsUsingBlock:^(NSObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [codingArray addObject:obj.mj_keyValues];
            
        }];
        [[NSUserDefaults standardUserDefaults]setObject:codingArray forKey:hashOfKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:hashOfKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


+ (void)deleteCache {
    [[[[self sharedInstance] chacheKeySet]allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:obj];
    }];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:nil];
    
}

//计算出大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

@end

@interface NetWorkTool()

@property (nonatomic, assign)BOOL isNetWorkReachable;

@property (nonatomic, strong)NSMutableDictionary *retryRequestTable;

@end


@implementation NetWorkTool


+ (instancetype)sharedInstance
{
    static NetWorkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NetWork" ofType:@"plist"];
        NSMutableDictionary *netWorkDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSURL *baseUrl = nil;
        baseUrl = [NSURL URLWithString:netWorkDict[@"BackendApiHost"]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 10.0;
        instance = [[self alloc]initWithBaseURL:baseUrl sessionConfiguration:config];
        
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
        [instance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [instance.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"ACCESS_KEY"] forHTTPHeaderField:@"Authorization"];
//        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
//        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.retryRequestTable = [NSMutableDictionary dictionary];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        //如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = NO;
        //validatesDomainName 是否需要验证域名，默认为YES；
        securityPolicy.validatesDomainName = NO;
        instance.securityPolicy  = securityPolicy;
        instance.isNetWorkReachable = YES;
        [instance addObserver];
        
    });
    
    return instance;
    
}

+ (BOOL)isNetWorkReachable {
    return [[NetWorkTool sharedInstance]isNetWorkReachable];
}

- (void)retryGETRequestWithRetryCount:(NSInteger )count
                                error:(NSError *)error
                               action:(NSString *)action
                             setCache:(BOOL)setCache
                       readCacheFirst:(BOOL)readCacheFirst
                            parameter:(NSDictionary *)parameter
                         successBlock:(void (^)(id data, BOOL cache))successBlock
                           errorBlock:(void (^)(NSString *))errorBlock {
    
    if(count == 3) {
        
        [NetWorkTool simplifyGETAction:action
                              setCache:setCache
                        readCacheFirst:readCacheFirst
                             parameter:parameter
                          successBlock:^(id data, BOOL cache) {
                              successBlock(data,cache);
                          } errorBlock:^(NSError *error) {
                              if ([[NetWorkTool sharedInstance] isNetWorkReachable] == YES && error.code == -1001) {
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [NetWorkTool simplifyGETAction:action
                                                            setCache:setCache
                                                      readCacheFirst:readCacheFirst
                                                           parameter:parameter
                                                        successBlock:^(id data, BOOL cache) {
                                                            successBlock(data,cache);
                                                        } errorBlock:^(NSError *error) {
                                                            if ([[NetWorkTool sharedInstance] isNetWorkReachable] == YES && error.code == -1001) {
                                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                    [NetWorkTool simplifyGETAction:action
                                                                                          setCache:setCache
                                                                                    readCacheFirst:readCacheFirst
                                                                                         parameter:parameter
                                                                                      successBlock:^(id data, BOOL cache) {
                                                                                          successBlock(data,cache);
                                                                                          
                                                                                      } errorBlock:^(NSError *error) {
                                                                                          errorBlock(error.localizedDescription);
                                                                                          
                                                                                      }];
                                                                });
                                                            }
                                                        }];
                                  });
                              }
                              //
                          }
         ];
        
    }
    
}

- (void)addObserver {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 一共有四种状态
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                self.isNetWorkReachable = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.isNetWorkReachable = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.isNetWorkReachable = YES;
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                self.isNetWorkReachable = NO;
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock
{
    //    NSLog(@"%@",action);
    //    NSLog(@"%@",parameter);
    
    action = [action stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[NetWorkTool sharedInstance]POST:action parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        //        NSLog(@"%@",responseObject);
        
        successBlock(nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock(error.localizedDescription);
        //        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}
+ (void)POSTAction:(NSString *)LoginAction
      formDataParameter:(NSDictionary *)parameter
     progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock{
    [[NetWorkTool sharedInstance] POST:LoginAction parameters:NULL constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:parameter[@"username"] name:@"username"];
        [formData appendPartWithFormData:parameter[@"password"] name:@"password"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progressBlock){
            progressBlock(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error.localizedDescription);
    }];
}

+ (void)POSTAction:(NSString *)action
         parameter:(NSDictionary *)parameter
            images:(NSArray *)images
     progressBlock:(void(^)(CGFloat progress))progressBlock
      successBlock:(void (^)(id data))successBlock
        errorBlock:(void (^)(NSString *errorDesc))errorBlock
{
    //    NSLog(@"%@",action);
    //    NSLog(@"%@",parameter);
    
    
    [[NetWorkTool sharedInstance]POST:action parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [images enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 1) name:[NSString stringWithFormat:@"%lu",(unsigned long)idx] fileName:[NSString stringWithFormat:@"%lu.jpeg",(unsigned long)idx] mimeType:@"image/jpeg"];
        }];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            
            progressBlock(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        errorBlock(error.localizedDescription);
    }];
    
}

+ (void)GETAction:(NSString *)action
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *errorDesc))errorBlock{
    [[NetWorkTool sharedInstance]GET:action
                          parameters:parameter
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                            }
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                 responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                                 successBlock(responseObject, NO);
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 errorBlock(error.localizedDescription);
                             }];
}

+ (void)simplifyGETAction:(NSString *)action
                 setCache:(BOOL)setCache
           readCacheFirst:(BOOL)readCacheFirst
                parameter:(NSDictionary *)parameter
             successBlock:(void (^)(id data, BOOL cache))successBlock
               errorBlock:(void (^)(NSError *error))errorBlock {
    
    //    NSLog(@"%@",parameter);
    
    
    
    if (readCacheFirst) {
        id cacheData = [BTNetCacheTool getJSONCacheWithURL:action parameter:parameter];
        if ([cacheData isKindOfClass:[NSData class]]) {
            cacheData = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        }
        if (cacheData) {
            successBlock(cacheData,YES);
        }
    }
    [[NetWorkTool sharedInstance]GET:action
                          parameters:parameter
                            progress:^(NSProgress * _Nonnull uploadProgress) {
                                
                                
                                
                            }
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 //        [SVProgressHUD dismiss];
                                 
                                 if (setCache && responseObject) {
                                     [BTNetCacheTool setJSONCacheWithURL:action parameter:parameter cacheDict:responseObject];
                                 }
                                 responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                                 //        NSLog(@"%@",responseObject);
                                 
                                 
                                 
                                 
                                 successBlock(responseObject, NO);
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 errorBlock(error);
                                 
                                 
                                 
                                 
                                 //         NSLog(@"----------------------------------------------------------------");
                                 
                             }];
    
    
}

+ (void)GETAction:(NSString *)action
         setCache:(BOOL)setCache
   readCacheFirst:(BOOL)readCacheFirst
        parameter:(NSDictionary *)parameter
     successBlock:(void (^)(id data, BOOL cache))successBlock
       errorBlock:(void (^)(NSString *))errorBlock
{
    
    
    
    if (readCacheFirst) {
        
        id cacheData = [BTNetCacheTool getJSONCacheWithURL:action parameter:parameter];
        if ([cacheData isKindOfClass:[NSData class]]) {
            cacheData = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        }
        if (cacheData) {
            successBlock(cacheData,YES);
        }
        
    }
    
    [[NetWorkTool sharedInstance]GET:action parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (setCache && responseObject) {
            [BTNetCacheTool setJSONCacheWithURL:action parameter:parameter cacheDict:responseObject];
        }
        //        [SVProgressHUD dismiss];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        //        NSLog(@"%@",responseObject);
        //        NSDate *receiveTime = [NSDate date];
        //        NSLog(@"----------------------------------------------------------------\n");
        //        NSLog(@"%@\n%@\nSendTime:%@\nReceiveTime:%@\n%@\n",action,parameter,sendTime,receiveTime,responseObject);
        //        NSLog(@"----------------------------------------------------------------\n");
        //
        //        NSLog(@"%d",setCache && responseObject);
        
        
        
        successBlock(responseObject, NO);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        //        NSLog(@"💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀\n");
        //        NSLog(@"%@\n%@\nErrorDescription:%@\n",action,parameter,error.localizedDescription);
        //        NSLog(@"💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀\n");
        
        if ([[NetWorkTool sharedInstance] isNetWorkReachable] == YES && error.code == -1001) {
            
            [[NetWorkTool sharedInstance]retryGETRequestWithRetryCount:3
                                                                 error:error
                                                                action:action
                                                              setCache:setCache
                                                        readCacheFirst:readCacheFirst
                                                             parameter:parameter
                                                          successBlock:successBlock errorBlock:errorBlock];
            
            
            
        }else if ([[NetWorkTool sharedInstance] isNetWorkReachable] == NO && error.code == -1001) {
            errorBlock(@"Network is not reachable");
            
        }
        else {
            errorBlock(error.localizedDescription);
        }
        
        
        
        //         NSLog(@"----------------------------------------------------------------");
        
    }];
    
    
    
}





@end
