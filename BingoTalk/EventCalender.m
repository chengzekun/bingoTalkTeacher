//
//  EventCalender.m
//  bingoTalkApp
//
//  Created by cheng on 2019/4/13.
//  Copyright © 2019 Angelo. All rights reserved.
//

#import "EventCalender.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@implementation EventCalender : NSObject
static EventCalender *calendar;

+ (instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalender alloc] init];
    });
    
    return calendar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay{
    __weak typeof(self) weakSelf = self;
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    [strongSelf showAlert:@"Failed to add, please try again later."];
                    
                }else if (!granted){
                    [strongSelf showAlert:@"Calendar is not allowed, please allow this App to use calendar in settings."];
                    
                }else{
                    
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = NO;
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*30.0]];

                    //添加提醒
//                    if (alarmArray && alarmArray.count > 0) {
                    
//                        for (NSString *timeString in alarmArray) {
//                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
//                        }
//                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [strongSelf showAlert:@"Events have been added to the system calendar."];
                    
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end
