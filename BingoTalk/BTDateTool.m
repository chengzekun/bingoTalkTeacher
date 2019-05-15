//
//  BTDateTool.m
//  BingoTalk
//
//  Created by cheng on 2019/4/21.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "BTDateTool.h"

@implementation BTDateTool
//算出当前周一到周日时间
+(NSArray *)backToPassedTimeWithWeeksNumber:(NSInteger)number
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:- 7 * 24 * 3600 * number];
    //滚动后，算出当前日期所在的周（周一－周日）
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:date];
    NSInteger daycount = [comp weekday] - 2;
    
    NSDate *weekdaybegin=[date dateByAddingTimeInterval:-daycount*60*60*24];
    NSDate *weekdayend = [date dateByAddingTimeInterval:((6-daycount)*60*60*24)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdaybegin];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:weekdayend];
    
    NSDate *startDate = [calendar dateFromComponents:components];//这个不能改
    
    NSDate *startDate1 = [calendar dateFromComponents:components1];
    NSDate *endDate1 = [calendar dateByAddingUnit:NSCalendarUnitHour value:23 toDate:startDate1 options:0];
    endDate1 = [calendar dateByAddingUnit:NSCalendarUnitMinute value:59 toDate:endDate1 options:0];

    //获取今天0点到明天0点的时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    //2019-04-21+23:59:00
    [formatter1 setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    NSString *str1 = [formatter1 stringFromDate:startDate];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    NSString *str2 = [formatter2 stringFromDate:endDate1];
    
    NSArray *arr = @[str1,str2];
    return arr;
}

+(NSMutableArray *)backWeeksTimeNumber:(NSInteger)number
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:- 7 * 24 * 3600 * number];
    //滚动后，算出当前日期所在的周（周一－周日）
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comp = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [comp weekday] - 1 ;
    // 得到几号
    NSInteger day = [comp day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == -1)
    {   firstDiff = 1;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [gregorian firstWeekday] - weekDay;
        lastDiff = 8 - weekDay;
    }
    NSMutableArray *currentWeeks = [self getCurrentWeeksWithFirstDiff:firstDiff lastDiff:lastDiff];
    
    return currentWeeks;
}
+(NSMutableArray *)getCurrentWeeksWithFirstDiff:(NSInteger)first lastDiff:(NSInteger)last
{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = first; i < last + 1; i ++)
    {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zn_CN"]];
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}



@end
