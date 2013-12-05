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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged) name:@"SNSettingsChanged" object:nil];
        self.learn = YES;
    }
    
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    if (self.enabled)
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
    notification.userInfo = @{@"SNAlarm":[NSKeyedArchiver archivedDataWithRootObject:self]};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)settingsChanged
{
    if (self.enabled)
        [self schedule];
}

- (NSDate *)dateAdjustedForSleepCycle
{
    // adjust alarm time backwards to match sleep cycle
    NSInteger sleepCycle = [SNSettings sleepCycle] * 60;
    NSDate *now = [[NSDate date] dateRoundedToMinutes];
    NSDate *alarmTime = self.date;
    
    // add 14 minutes for time to fall asleep for now, this could be controlled by neural network or average number of snoozes
    NSTimeInterval wakeTime = [now timeIntervalSinceReferenceDate] + 14 * 60;
    NSTimeInterval latestTime = [alarmTime timeIntervalSinceReferenceDate];
    
    // find nearest 90 minute interval from now up to wake time
    while (wakeTime + sleepCycle <= latestTime)
        wakeTime += sleepCycle;
    
    return [NSDate dateWithTimeIntervalSinceReferenceDate:wakeTime];
}

- (void)adjustForSleepCycle
{
    self.date = [self dateAdjustedForSleepCycle];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        _date = [aDecoder decodeObjectForKey:@"date"];
        _enabled = [aDecoder decodeBoolForKey:@"enabled"];
        _learn = [aDecoder decodeBoolForKey:@"learn"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeBool:self.enabled forKey:@"enabled"];
    [aCoder encodeBool:self.learn forKey:@"learn"];
}

@end
