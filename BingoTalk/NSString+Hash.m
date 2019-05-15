//
//  NSString+Hash.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/6.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(Hash)

- (NSString *)hashValueWithType:(HashType)type
{
    return [self hashValueWithCirculationTimes:1 type:type];
}

- (NSString *)MD5Value
{
    return [self MD5ValueWithCirculationTimes:1];
}

- (NSString *)SHA1Value
{
    return [self SHA1ValueWithCirculationTimes:1];
}

- (NSString *)hashValueWithCirculationTimes:(NSUInteger)times type:(HashType)type
{
    NSAssert(type ==HashTypeMD5 || type == HashTypeSHA1, @"%@---%s---type参数错误",[NSString class],__func__);
    
    if (type == HashTypeMD5) {
        return  [self MD5ValueWithCirculationTimes:times];
        
    }else if (type == HashTypeSHA1){
        return  [self SHA1ValueWithCirculationTimes:times];
        
    }
    
    return nil;
}



- (NSString *)MD5ValueWithCirculationTimes:(NSUInteger)times
{
    if (times == 0) {
        return self;
    }
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    times--;
    return [output MD5ValueWithCirculationTimes:times];
}


- (NSString *)SHA1ValueWithCirculationTimes:(NSUInteger)times
{
    if (times == 0) {
        
        return self;
    }
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    times--;
    
    return [output SHA1ValueWithCirculationTimes:times];
}

@end
