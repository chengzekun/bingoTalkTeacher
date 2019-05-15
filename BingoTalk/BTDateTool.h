//
//  BTDateTool.h
//  BingoTalk
//
//  Created by cheng on 2019/4/21.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BTDateTool : NSObject
//获取当前周的时间
+(NSArray *)backToPassedTimeWithWeeksNumber:(NSInteger)number;
+(NSMutableArray *)backWeeksTimeNumber:(NSInteger)number;
//获取某时区的时间

@end


