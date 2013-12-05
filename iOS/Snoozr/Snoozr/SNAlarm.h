//
//  SNAlarm.h
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAlarm : NSObject <NSCoding>

@property (nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL learn;

- (void)cancel;
- (void)schedule;

- (NSDate *)dateAdjustedForSleepCycle;
- (void)adjustForSleepCycle;

@end
