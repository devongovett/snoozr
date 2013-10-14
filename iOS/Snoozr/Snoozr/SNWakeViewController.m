//
//  SNWakeViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNWakeViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Hex.h"
#import <sys/time.h>

@implementation SNWakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton.backgroundColor = [UIColor colorWithHex:0xBF2E2D];
    self.snoozeButton.backgroundColor = [UIColor colorWithHex:0x42C54F];
    
    [self updateEveryMinute];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    [super update];
    [self updateTitle];
}

- (void)updateTitle
{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSHourCalendarUnit fromDate:date];
    if (components.hour >= 12) {
        self.titleLabel.text = @"Good afternoon!";
    } else {
        self.titleLabel.text = @"Good morning!";
    }
}

- (void)updateEveryMinute
{
    [self update];
    
    // get the current time
    struct timespec startPopTime;
    gettimeofday((struct timeval *) &startPopTime, NULL);
    
    // trim the time
    startPopTime.tv_sec -= (startPopTime.tv_sec % 60);
    startPopTime.tv_sec += 60;
    
    dispatch_time_t time = dispatch_walltime(&startPopTime, 0);
    dispatch_after(time, dispatch_get_main_queue(), ^(void) {
        [self updateEveryMinute];
    });
}

@end
