//
//  SNAlarm.h
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Represents an alarm
 */
@interface SNAlarm : NSObject <NSCoding>

/**
 *  The original date the alarm was set for, excluding snoozes
 */
@property (nonatomic, copy) NSDate *originalDate;

/**
 *  The date the alarm should go off
 */
@property (nonatomic, copy) NSDate *date;

/**
 *  Whether the alarm is enabled
 */
@property (nonatomic) BOOL enabled;

/**
 *  Whether to learn from this alarm
 */
@property (nonatomic) BOOL learn;

/**
 *  Cancels the alarm
 */
- (void)cancel;

/**
 *  Schedules the alarm for the specified date
 */
- (void)schedule;

/**
 *  @return Adjusted date for the user's sleep cycle settings
 */
- (NSDate *)dateAdjustedForSleepCycle;

/**
 *  Adjusts the date for the user's sleep cycle, using the date returned by dateAdjustedForSleepCycle
 */
- (void)adjustForSleepCycle;

@end
