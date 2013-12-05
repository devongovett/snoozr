//
//  UIDate+Greeting.h
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//


/**
 *  Adds some useful methods to NSDate
 */
@interface NSDate (Snoozr)

/**
 *  Generates a greeting string, depending on morning, evening and night
 */
@property (readonly) NSString *greeting;

/**
 *  Rounds a date to the nearest minute
 *
 *  @return Rounded date
 */
- (NSDate *)dateRoundedToMinutes;

/**
 *  Gets a date for "tomorrow". Tomorrow is considered the same day as today if its before 5am.
 *
 *  @return Date for tomorrow
 */
+ (NSDate *)tomorrow;

/**
 *  Gets a date for the next minute from now
 *
 *  @return Date for the next minute
 */
+ (NSDate *)nextMinute;

@end
