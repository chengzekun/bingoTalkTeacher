//
//  EventCalender.h
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCalender : NSObject

+(instancetype)sharedEventCalendar;

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay;
//alarmArray:(NSArray *)alarmArray

@end

