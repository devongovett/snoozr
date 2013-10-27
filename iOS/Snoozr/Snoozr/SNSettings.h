//
//  SNSettings.h
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSound.h"

@interface SNSettings : NSObject

+ (NSInteger)numSnoozes;
+ (void)setNumSnoozes:(NSInteger)numSnoozes;

+ (NSInteger)sleepCycle;
+ (void)setSleepCycle:(NSInteger)sleepCycle;

+ (SNSound *)alarmSound;
+ (void)setAlarmSound:(SNSound *)alarmSound;

@end
