//
//  SNAlarm.m
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNAlarm.h"
#import "SNSettings.h"
#import "NSDate+Greeting.h"

@implementation SNAlarm

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // update notification when alarmSound setting changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(schedule) name:@"SNSettingsChanged" object:nil];
    }
    
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [self schedule];
}

- (void)setEnabled:(BOOL)isEnabled
{
    if (_enabled == isEnabled)
        return;
    
    _enabled = isEnabled;
    
    if (isEnabled)
        [self schedule];
    else
        [self cancel];
}

- (void)cancel
{
    _enabled = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)schedule
{
    if (self.enabled)
        [self cancel];
    
    _enabled = YES;
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = self.date;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.alertBody = [NSString stringWithFormat:@"%@ It's time to wake up!", self.date.greeting];
    notification.soundName = [[SNSettings alarmSound] filename];
    notification.repeatInterval = NSCalendarUnitMinute;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
