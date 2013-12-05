//
//  SNSettings.h
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSound.h"

/**
 *  Stores user settings for Snoozr in NSUserDefaults.
 */
@interface SNSettings : NSObject

/**
 *  @return Maximum number of snoozes that the user has set, or 3 by default
 */
+ (NSInteger)numSnoozes;

/**
 *  Sets the maximum number of snoozes that the user has set
 *
 *  @param numSnoozes Number of snoozes
 */
+ (void)setNumSnoozes:(NSInteger)numSnoozes;

/**
 *  Gets the user's sleep cycle info
 *
 *  @return Minutes per sleep cycle, or 90 minutes by default
 */
+ (NSInteger)sleepCycle;

/**
 *  Setsthe user's sleep cycle settings
 *
 *  @param sleepCycle Minutes per sleep cycle
 */
+ (void)setSleepCycle:(NSInteger)sleepCycle;

/**
 *  Gets the alarm sound to play
 *
 *  @return SNSound object representing the sound to play when alarm goes off
 */
+ (SNSound *)alarmSound;

/**
 *  Sets the alarm sound settings
 *
 *  @param alarmSound SNSound object representing the sound to play when alarm goes off
 */
+ (void)setAlarmSound:(SNSound *)alarmSound;

@end
