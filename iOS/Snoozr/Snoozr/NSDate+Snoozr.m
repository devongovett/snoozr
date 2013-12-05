//
//  UIDate+Greeting.m
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "NSDate+Snoozr.h"

@implementation NSDate (Snoozr)

- (NSString *)greeting
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSHourCalendarUnit fromDate:self];
    
    if (components.hour >= 17) { // 5pm
        return @"Good evening!";
    } else if (components.hour >= 12) {
        return @"Good afternoon!";
    } else {
        return @"Good morning!";
    }
}

- (NSDate *)dateRoundedToMinutes
{
    NSTimeInterval timeInterval = floor([self timeIntervalSinceReferenceDate] / 60) * 60;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
}

+ (NSDate *)tomorrow
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit) fromDate:now];
    
    // if past 5am, increase the day, otherwise "tomorrow" is
    // technically the same day (after sleep)
    if (components.hour > 5)
        components.day++;
    
    components.hour = 0;
    return [calendar dateFromComponents:components];
}

@end
