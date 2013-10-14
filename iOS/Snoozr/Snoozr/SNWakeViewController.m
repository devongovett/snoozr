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

void runBlockEveryMinute(dispatch_block_t block);

@implementation SNWakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton.backgroundColor = [UIColor colorWithHex:0xBF2E2D];
    self.snoozeButton.backgroundColor = [UIColor colorWithHex:0x42C54F];
    
    runBlockEveryMinute(^{
        [self update];
    });
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

@end

void runBlockEveryMinute(dispatch_block_t block)
{
    block(); // initial block call
    
    // get the current time
    struct timespec startPopTime;
    gettimeofday((struct timeval *) &startPopTime, NULL);
    
    // trim the time
    startPopTime.tv_sec -= (startPopTime.tv_sec % 60);
    startPopTime.tv_sec += 60;
    
    dispatch_time_t time = dispatch_walltime(&startPopTime, 0);
    
    __block dispatch_block_t afterBlock = ^(void) {
        block();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 60), dispatch_get_main_queue(), afterBlock);
    };
    
    dispatch_after(time, dispatch_get_main_queue(), afterBlock); // start the 'timer' going
}
