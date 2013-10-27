//
//  SNSettings.m
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNSettings.h"

@implementation SNSettings

+ (NSInteger)numSnoozes
{
    NSInteger numSnoozes = [[NSUserDefaults standardUserDefaults] integerForKey:@"numSnoozes"];
    return numSnoozes ? numSnoozes : 3;
}

+ (void)setNumSnoozes:(NSInteger)numSnoozes
{
    [[NSUserDefaults standardUserDefaults] setInteger:numSnoozes forKey:@"numSnoozes"];
    [self save];
}

+ (NSInteger)sleepCycle
{
    NSInteger sleepCycle = [[NSUserDefaults standardUserDefaults] integerForKey:@"sleepCycle"];
    return sleepCycle ? sleepCycle : 90;
}

+ (void)setSleepCycle:(NSInteger)sleepCycle
{
    [[NSUserDefaults standardUserDefaults] setInteger:sleepCycle forKey:@"sleepCycle"];
    [self save];
}

+ (SNSound *)alarmSound
{
    NSData *alarmSound = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarmSound"];
    if (!alarmSound)
        return [SNSound defaultSound];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:alarmSound];
}

+ (void)setAlarmSound:(SNSound *)alarmSound
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:alarmSound];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"alarmSound"];
    [self save];
}

+ (void)save
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SNSettingsChanged" object:self];
}

@end
