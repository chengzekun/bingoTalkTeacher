//
//  NSDate+ZYDateTools.h
//  LZCalendar
//
//  Email:lztuna04@gmail.com
//  welcome to issue me or whatever you want,I will help you.
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//
#import "NSDate+ZKDateTools.h"
#import <CoreGraphics/CoreGraphics.h>

#define SECONDS_IN_HOUR 3600
#define SECONDS_IN_MINUTE 60


typedef NS_ENUM(NSUInteger, ZYDateComponent){
    ZYDateComponentEra,
    ZYDateComponentYear,
    ZYDateComponentMonth,
    ZYDateComponentDay,
    ZYDateComponentHour,
    ZYDateComponentMinute,
    ZYDateComponentSecond,
    ZYDateComponentWeekday,
    ZYDateComponentWeekdayOrdinal,
    ZYDateComponentQuarter,
    ZYDateComponentWeekOfMonth,
    ZYDateComponentWeekOfYear,
    ZYDateComponentYearForWeekOfYear,
    ZYDateComponentDayOfYear
};

typedef NS_ENUM(NSUInteger, DateAgoFormat){
    DateAgoLong,
    DateAgoLongUsingNumericDatesAndTimes,
    DateAgoLongUsingNumericDates,
    DateAgoLongUsingNumericTimes,
    DateAgoShort
};

typedef NS_ENUM(NSUInteger, DateAgoValues){
    YearsAgo,
    MonthsAgo,
    WeeksAgo,
    DaysAgo,
    HoursAgo,
    MinutesAgo,
    SecondsAgo
};

static const unsigned int allCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

static NSString *defaultCalendarIdentifier = nil;
static NSCalendar *implicitCalendar = nil;

@implementation NSDate (ZYDateTools)

+ (void)load {
    [self czk_setDefaultCalendarIdentifier:NSCalendarIdentifierGregorian];
}

#pragma mark - Time Ago

+ (NSString *)czk_monthDescStringWithMonth:(NSInteger)month {
    
    switch (month) {
        case 1:
            return @"Jan";
            break;
        case 2:
            return @"Feb";
            break;
        case 3:
            return @"Mar";
            break;
        case 4:
            return @"Apr";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"Jun";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"Aug";
            break;
        case 9:
            return @"Sep";
            break;
        case 10:
            return @"Oct";
            break;
        case 11:
            return @"Nov";
            break;
        case 12:
            return @"Dec";
            break;
        default:
            break;
    }
    return nil;
    
}

- (NSInteger)czk_daysCount {
    
    
    NSUInteger month = self.czk_month;
    if (month != 2) {
        
        if ([self czk_is31DaysMonth:month]) {
            
            return 31;
        }else {
            
            return 30;
        }
        
    }
    
    if ([self czk_isInLeapYear]) {
        
        return 29;
        
    }else {
        
        return 28;
    }
    
    
    
    
}

- (BOOL)czk_isToday {
    
    return [self czk_daysOffsetWithDate:[NSDate date]] == 0;
}

- (BOOL)czk_is31DaysMonth:(NSUInteger )month {
    
    __block BOOL is31DayMonth = NO;
    NSArray *array = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (month == [obj integerValue]) {
            
            is31DayMonth = YES;
        }
        
    }];
    
    
    return is31DayMonth;
    
    
}



+ (NSDate *) czk_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate{
    
    NSDate *date = [self czk_dateWithYear:aDate.czk_year month:aDate.czk_month day:aDate.czk_day hour:0 minute:0 second:0];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    date = [NSDate dateWithTimeIntervalSince1970:interval + 8 * 3600];
    
    return date;
}






- (NSString *)czk_getLocaleFormatUnderscoresWithValue:(double)value {
    NSString *localeCode = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
    
    if([localeCode isEqualToString:@"ru"] || [localeCode isEqualToString:@"uk"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) {
            return @"";
        }
        
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  {
            return @"_";
        }
        
        if(Y == 1 && XY != 11) {
            return @"__";
        }
    }
    
    
    
    return @"";
}

#pragma mark - Date Components Without Calendar

- (NSInteger)czk_era{
    return [self czk_componentForDate:self type:ZYDateComponentEra calendar:nil];
}


- (NSInteger)czk_year{
    return [self czk_componentForDate:self type:ZYDateComponentYear calendar:nil];
}


- (NSInteger)czk_month{
    return [self czk_componentForDate:self type:ZYDateComponentMonth calendar:nil];
}


- (NSInteger)czk_day{
    return [self czk_componentForDate:self type:ZYDateComponentDay calendar:nil];
}


- (NSInteger)czk_hour{
    return [self czk_componentForDate:self type:ZYDateComponentHour calendar:nil];
}


- (NSInteger)czk_minute {
    return [self czk_componentForDate:self type:ZYDateComponentMinute calendar:nil];
}


- (NSInteger)czk_second{
    return [self czk_componentForDate:self type:ZYDateComponentSecond calendar:nil];
}


- (NSInteger)czk_weekday{
    return [self czk_componentForDate:self type:ZYDateComponentWeekday calendar:nil];
}


- (NSInteger)czk_weekdayOrdinal{
    return [self czk_componentForDate:self type:ZYDateComponentWeekdayOrdinal calendar:nil];
}


- (NSInteger)czk_quarter{
    return [self czk_componentForDate:self type:ZYDateComponentQuarter calendar:nil];
}


- (NSInteger)czk_weekOfMonth{
    return [self czk_componentForDate:self type:ZYDateComponentWeekOfMonth calendar:nil];
}


- (NSInteger)czk_weekOfYear{
    return [self czk_componentForDate:self type:ZYDateComponentWeekOfYear calendar:nil];
}


- (NSInteger)czk_yearForWeekOfYear{
    return [self czk_componentForDate:self type:ZYDateComponentYearForWeekOfYear calendar:nil];
}


- (NSInteger)czk_daysInMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:self];
    return days.length;
}


- (NSInteger)czk_dayOfYear{
    return [self czk_componentForDate:self type:ZYDateComponentDayOfYear calendar:nil];
}


- (NSInteger)czk_daysInYear{
    if (self.czk_isInLeapYear) {
        return 366;
    }
    
    return 365;
}


- (BOOL)czk_isInLeapYear{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:allCalendarUnitFlags fromDate:self];
    
    if (dateComponents.year%400 == 0){
        return YES;
    }
    else if (dateComponents.year%100 == 0){
        return NO;
    }
    else if (dateComponents.year%4 == 0){
        return YES;
    }
    
    return NO;
}

- (BOOL)czk_isWeekend {
    
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSRange weekdayRange            = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components    = [calendar components:NSCalendarUnitWeekday
                                                  fromDate:self];
    NSUInteger weekdayOfSomeDate    = [components weekday];
    
    BOOL result = NO;
    
    if (weekdayOfSomeDate == weekdayRange.location || weekdayOfSomeDate == weekdayRange.length)
        result = YES;
    
    return result;
    
}

- (BOOL)lcck_isToday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:otherDate];
}


- (BOOL)czk_isSameDay:(NSDate *)date {
    return [self czk_daysOffsetWithDate:date] == 0;
}


+ (BOOL)czk_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *dateOne = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:compareDate];
    NSDate *dateTwo = [cal dateFromComponents:components];
    
    return [dateOne isEqualToDate:dateTwo];
}

#pragma mark - Date Components With Calendar

- (NSInteger)czk_eraWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentEra calendar:calendar];
}


- (NSInteger)czk_yearWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentYear calendar:calendar];
}


- (NSInteger)czk_monthWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentMonth calendar:calendar];
}

- (NSInteger)czk_dayWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentDay calendar:calendar];
}

- (NSInteger)czk_hourWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentHour calendar:calendar];
}


- (NSInteger)czk_minuteWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentMinute calendar:calendar];
}


- (NSInteger)czk_secondWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentSecond calendar:calendar];
}

- (NSInteger)czk_weekdayWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentWeekday calendar:calendar];
}

- (NSInteger)czk_weekdayOrdinalWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentWeekdayOrdinal calendar:calendar];
}


- (NSInteger)czk_quarterWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentQuarter calendar:calendar];
}


- (NSInteger)czk_weekOfMonthWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentWeekOfMonth calendar:calendar];
}


- (NSInteger)czk_weekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentWeekOfYear calendar:calendar];
}


- (NSInteger)czk_yearForWeekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentYearForWeekOfYear calendar:calendar];
}



- (NSInteger)czk_dayOfYearWithCalendar:(NSCalendar *)calendar{
    return [self czk_componentForDate:self type:ZYDateComponentDayOfYear calendar:calendar];
}

- (NSInteger)czk_componentForDate:(NSDate *)date type:(ZYDateComponent)component calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] czk_implicitCalendar];
    }
    
    unsigned int unitFlags = 0;
    
    if (component == ZYDateComponentYearForWeekOfYear) {
        unitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear;
    }
    else {
        unitFlags = allCalendarUnitFlags;
    }
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    switch (component) {
        case ZYDateComponentEra:
            return [dateComponents era];
        case ZYDateComponentYear:
            return [dateComponents year];
        case ZYDateComponentMonth:
            return [dateComponents month];
        case ZYDateComponentDay:
            return [dateComponents day];
        case ZYDateComponentHour:
            return [dateComponents hour];
        case ZYDateComponentMinute:
            return [dateComponents minute];
        case ZYDateComponentSecond:
            return [dateComponents second];
        case ZYDateComponentWeekday:
            return [dateComponents weekday];
        case ZYDateComponentWeekdayOrdinal:
            return [dateComponents weekdayOrdinal];
        case ZYDateComponentQuarter:
            return [dateComponents quarter];
        case ZYDateComponentWeekOfMonth:
            return [dateComponents weekOfMonth];
        case ZYDateComponentWeekOfYear:
            return [dateComponents weekOfYear];
        case ZYDateComponentYearForWeekOfYear:
            return [dateComponents yearForWeekOfYear];
        case ZYDateComponentDayOfYear:
            return [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
        default:
            break;
    }
    
    return 0;
}

#pragma mark - Date Creating
+ (NSDate *)czk_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    return [NSDate czk_dateStandardFormatTimeZeroWithDate:[self czk_dateWithYear:year month:month day:day hour:0 minute:0 second:0]];
}

+ (NSDate *)czk_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDate *nsDate = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year   = year;
    components.month  = month;
    components.day    = day;
    components.hour   = hour;
    components.minute = minute;
    components.second = second;
    
    nsDate = [[[self class] czk_implicitCalendar] dateFromComponents:components];
    
    return nsDate;
}

+ (NSDate *)czk_dateWithString:(NSString *)dateString formatString:(NSString *)formatString {
    
    return [self czk_dateWithString:dateString formatString:formatString timeZone:[NSTimeZone systemTimeZone]];
}

+ (NSDate *)czk_dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone {
    
    static NSDateFormatter *parser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parser = [[NSDateFormatter alloc] init];
    });
    
    parser.dateStyle = NSDateFormatterNoStyle;
    parser.timeStyle = NSDateFormatterNoStyle;
    parser.timeZone = timeZone;
    parser.dateFormat = formatString;
    
    return [parser dateFromString:dateString];
}


#pragma mark - Date Editing
#pragma mark Date By Adding

- (NSDate *)czk_dateByAddingYears:(NSInteger)years{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)czk_dateByAddingDays:(NSInteger)days{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [NSDate czk_dateStandardFormatTimeZeroWithDate:[calendar dateByAddingComponents:components toDate:self options:0]];
}


- (NSDate *)czk_dateByAddingHours:(NSInteger)hours{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateByAddingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateByAddingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark Date By Subtracting
- (NSDate *)czk_dateBySubtractingYears:(NSInteger)years{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-1*years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingMonths:(NSInteger)months{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1*months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:-1*weeks];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingDays:(NSInteger)days{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1*days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingHours:(NSInteger)hours{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:-1*hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-1*minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)czk_dateBySubtractingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[self class] czk_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:-1*seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - Date Comparison
#pragma mark Time From

- (NSInteger)czk_yearsFrom:(NSDate *)date {
    return [self czk_yearsFrom:date calendar:nil];
}


- (NSInteger)czk_monthsFrom:(NSDate *)date {
    if (!date) {
        return 0;
    }
    return [self czk_monthsFrom:date calendar:nil];
}


- (NSInteger)czk_weeksFrom:(NSDate *)date {
    return [self czk_weeksFrom:date calendar:nil];
}


- (NSInteger)czk_daysFrom:(NSDate *)date {
    return [self czk_daysFrom:date calendar:nil];
}


- (double)czk_hoursFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_HOUR;
}


- (double)czk_minutesFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_MINUTE;
}


- (double)czk_secondsFrom:(NSDate *)date {
    return [self timeIntervalSinceDate:date];
}

#pragma mark Time From With Calendar

- (NSInteger)czk_yearsFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] czk_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.year;
}


- (NSInteger)czk_monthsFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] czk_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    return multiplier*(components.month + 12*components.year);
}


- (NSInteger)czk_weeksFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] czk_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.weekOfYear;
}


- (NSInteger)czk_daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] czk_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    return multiplier*components.day;
}

#pragma mark Time Until

- (NSInteger)czk_yearsUntil{
    return [self czk_yearsLaterThan:[NSDate date]];
}


- (NSInteger)czk_monthsUntil{
    return [self czk_monthsLaterThan:[NSDate date]];
}


- (NSInteger)czk_weeksUntil{
    return [self czk_weeksLaterThan:[NSDate date]];
}


- (NSInteger)czk_daysUntil{
    return [self czk_daysLaterThan:[NSDate date]];
}


- (double)czk_hoursUntil{
    return [self czk_hoursLaterThan:[NSDate date]];
}


- (double)czk_minutesUntil{
    return [self czk_minutesLaterThan:[NSDate date]];
}


- (double)czk_secondsUntil{
    return [self czk_secondsLaterThan:[NSDate date]];
}

#pragma mark Time Ago

- (NSInteger)czk_yearsAgo{
    return [self czk_yearsEarlierThan:[NSDate date]];
}


- (NSInteger)czk_monthsAgo{
    return [self czk_monthsEarlierThan:[NSDate date]];
}


- (NSInteger)czk_weeksAgo{
    return [self czk_weeksEarlierThan:[NSDate date]];
}


- (NSInteger)czk_daysAgo{
    return [self czk_daysEarlierThan:[NSDate date]];
}


- (double)czk_hoursAgo{
    return [self czk_hoursEarlierThan:[NSDate date]];
}


- (double)czk_minutesAgo{
    return [self czk_minutesEarlierThan:[NSDate date]];
}


- (double)czk_secondsAgo{
    return [self czk_secondsEarlierThan:[NSDate date]];
}

#pragma mark Earlier Than

- (NSInteger)czk_yearsEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_yearsFrom:date], 0));
}


- (NSInteger)czk_monthsEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_monthsFrom:date], 0));
}


- (NSInteger)czk_weeksEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_weeksFrom:date], 0));
}


- (NSInteger)czk_daysEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_daysFrom:date], 0));
}


- (double)czk_hoursEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_hoursFrom:date], 0));
}


- (double)czk_minutesEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_minutesFrom:date], 0));
}


- (double)czk_secondsEarlierThan:(NSDate *)date {
    return ABS(MIN([self czk_secondsFrom:date], 0));
}

#pragma mark Later Than

- (NSInteger)czk_yearsLaterThan:(NSDate *)date {
    return MAX([self czk_yearsFrom:date], 0);
}


- (NSInteger)czk_monthsLaterThan:(NSDate *)date {
    return MAX([self czk_monthsFrom:date], 0);
}


- (NSInteger)czk_weeksLaterThan:(NSDate *)date {
    return MAX([self czk_weeksFrom:date], 0);
}


- (NSInteger)czk_daysLaterThan:(NSDate *)date {
    return MAX([self czk_daysFrom:date], 0);
}


- (double)czk_hoursLaterThan:(NSDate *)date {
    return MAX([self czk_hoursFrom:date], 0);
}


- (double)czk_minutesLaterThan:(NSDate *)date {
    return MAX([self czk_minutesFrom:date], 0);
}


- (double)czk_secondsLaterThan:(NSDate *)date {
    return MAX([self czk_secondsFrom:date], 0);
}


#pragma mark Comparators

- (BOOL)czk_isEarlierThan:(NSDate *)date {
    return [self czk_daysOffsetWithDate:date] <0;
}

- (BOOL)czk_isLaterThan:(NSDate *)date {
    
    return [self czk_daysOffsetWithDate:date] >0;
}


- (BOOL)czk_isLaterThanOrEqualTo:(NSDate *)date {
    
    return  [self czk_daysOffsetWithDate:date] >= 0;
}


- (BOOL)czk_isEarlierThanOrEqualTo:(NSDate *)date {
    
    return  [self czk_daysOffsetWithDate:date] <= 0;
}


- (NSInteger) czk_daysOffsetWithDate:(NSDate *)date
{
    //只取年月日比较
    NSDate *dateSelf = [NSDate czk_dateStandardFormatTimeZeroWithDate:self];
    NSTimeInterval timeInterval = [dateSelf timeIntervalSince1970];
    NSDate *dateNow = [NSDate czk_dateStandardFormatTimeZeroWithDate:date];
    NSTimeInterval timeIntervalNow = [dateNow timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha/1800;
    NSInteger day = chaDay * 1;
    return day;
}

#pragma mark - Formatted Dates
#pragma mark Formatted With Style

- (NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style {
    return [self czk_formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone {
    return [self czk_formattedDateWithStyle:style timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale {
    return [self czk_formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:locale];
}


- (NSString *)czk_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark Formatted With Format

- (NSString *)czk_formattedDateWithFormat:(NSString *)format{
    return [self czk_formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)czk_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    return [self czk_formattedDateWithFormat:format timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)czk_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale {
    return [self czk_formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:locale];
}


- (NSString *)czk_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark - Helpers

+ (BOOL)czk_isLeapYear:(NSInteger)year{
    if (year%400){
        return YES;
    }
    else if (year%100){
        return NO;
    }
    else if (year%4){
        return YES;
    }
    
    return NO;
}


+ (NSString *)czk_defaultCalendarIdentifier {
    return defaultCalendarIdentifier;
}


+ (void)czk_setDefaultCalendarIdentifier:(NSString *)identifier {
    defaultCalendarIdentifier = [identifier copy];
    implicitCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:defaultCalendarIdentifier ?: NSCalendarIdentifierGregorian];
}


+ (NSCalendar *)czk_implicitCalendar {
    return implicitCalendar;
}

@end
