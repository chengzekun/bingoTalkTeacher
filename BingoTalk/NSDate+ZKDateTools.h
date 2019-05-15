//
//  NSDate+ZKDateTools.h
//  BingoTalk
//
//  Created by cheng on 2019/4/22.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSDate (ZKDateTools)

#pragma mark - Date Components Without Calendar
- (NSInteger)czk_era;
- (NSInteger)czk_year;
- (NSInteger)czk_month;
- (NSInteger)czk_day;
- (NSInteger)czk_hour;
- (NSInteger)czk_minute;
- (NSInteger)czk_second;
- (NSInteger)czk_weekday;
- (NSInteger)czk_weekdayOrdinal;
- (NSInteger)czk_quarter;
- (NSInteger)czk_weekOfMonth;
- (NSInteger)czk_weekOfYear;
- (NSInteger)czk_yearForWeekOfYear;
- (NSInteger)czk_daysInMonth;
- (NSInteger)czk_dayOfYear;
- (NSInteger)czk_daysInYear;
- (BOOL)czk_isInLeapYear;
- (BOOL)czk_isToday;
- (BOOL)czk_isWeekend;
- (BOOL)czk_isSameDay:(NSDate *)date;


#pragma mark - Date Components With Calendar


- (NSInteger)czk_eraWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_yearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_monthWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_dayWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_hourWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_minuteWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_secondWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_weekdayWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_weekdayOrdinalWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_quarterWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_weekOfMonthWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_weekOfYearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_yearForWeekOfYearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)czk_daysOffsetWithDate:(NSDate *)date;


+ (NSDate *)czk_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)czk_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)czk_dateWithString:(NSString *)dateString formatString:(NSString *)formatString;
+ (NSDate *)czk_dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone;

+ (NSDate *) czk_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;


- (NSDate *)czk_dateByAddingYears:(NSInteger)years;
- (NSDate *)czk_dateByAddingMonths:(NSInteger)months;
- (NSDate *)czk_dateByAddingDays:(NSInteger)days;
- (NSDate *)czk_dateByAddingHours:(NSInteger)hours;
- (NSDate *)czk_dateByAddingMinutes:(NSInteger)hours;


- (NSDate *)czk_dateBySubtractingYears:(NSInteger)years;
- (NSDate *)czk_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)czk_dateBySubtractingDays:(NSInteger)days;
- (NSDate *)czk_dateBySubtractingMinutes:(NSInteger)minutes;


-(NSInteger)czk_yearsFrom:(NSDate *)date;
-(NSInteger)czk_monthsFrom:(NSDate *)date;
-(NSInteger)czk_weeksFrom:(NSDate *)date;
-(NSInteger)czk_daysFrom:(NSDate *)date;
-(double)czk_hoursFrom:(NSDate *)date;
-(double)czk_minutesFrom:(NSDate *)date;
-(double)czk_secondsFrom:(NSDate *)date;

-(NSInteger)czk_yearsFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)czk_monthsFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)czk_weeksFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)czk_daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar;


-(NSInteger)czk_yearsUntil;
-(NSInteger)czk_monthsUntil;
-(NSInteger)czk_weeksUntil;
-(NSInteger)czk_daysUntil;
-(double)czk_hoursUntil;
-(double)czk_minutesUntil;
-(double)czk_secondsUntil;
#pragma mark Time Ago
-(NSInteger)czk_yearsAgo;
-(NSInteger)czk_monthsAgo;
-(NSInteger)czk_weeksAgo;
-(NSInteger)czk_daysAgo;
-(double)czk_hoursAgo;
-(double)czk_minutesAgo;
-(double)czk_secondsAgo;

#pragma mark Earlier Than
-(NSInteger)czk_yearsEarlierThan:(NSDate *)date;
-(NSInteger)czk_monthsEarlierThan:(NSDate *)date;
-(NSInteger)czk_weeksEarlierThan:(NSDate *)date;
-(NSInteger)czk_daysEarlierThan:(NSDate *)date;
-(double)czk_hoursEarlierThan:(NSDate *)date;
-(double)czk_minutesEarlierThan:(NSDate *)date;
-(double)czk_secondsEarlierThan:(NSDate *)date;
#pragma mark Later Than
-(NSInteger)czk_yearsLaterThan:(NSDate *)date;
-(NSInteger)czk_monthsLaterThan:(NSDate *)date;
-(NSInteger)czk_weeksLaterThan:(NSDate *)date;
-(NSInteger)czk_daysLaterThan:(NSDate *)date;
-(double)czk_hoursLaterThan:(NSDate *)date;
-(double)czk_minutesLaterThan:(NSDate *)date;
-(double)czk_secondsLaterThan:(NSDate *)date;
#pragma mark Comparators
-(BOOL)czk_isEarlierThan:(NSDate *)date;
-(BOOL)czk_isLaterThan:(NSDate *)date;
-(BOOL)czk_isEarlierThanOrEqualTo:(NSDate *)date;
-(BOOL)czk_isLaterThanOrEqualTo:(NSDate *)date;

- (NSInteger)czk_daysCount;

+ (NSString *)czk_monthDescStringWithMonth:(NSInteger )month;
#pragma mark - Formatted Dates
#pragma mark Formatted With Style

-(NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style;
-(NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone;
-(NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale;
-(NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
#pragma mark Formatted With Format
-(NSString *)czk_formattedDateWithFormat:(NSString *)format;
-(NSString *)czk_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;
-(NSString *)czk_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale;
-(NSString *)czk_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

#pragma mark - Helpers
+(NSString *)czk_defaultCalendarIdentifier;
+ (void)czk_setDefaultCalendarIdentifier:(NSString *)identifier;

@end


