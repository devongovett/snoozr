//
//  UIDate+Greeting.m
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "NSDate+Greeting.h"

@implementation NSDate (Greeting)

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
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    components.day++;
    return [calendar dateFromComponents:components];
}

@end
