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
{
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton.backgroundColor = [UIColor colorWithHex:0x42C54F];
    self.snoozeButton.backgroundColor = [UIColor colorWithHex:0xBF2E2D];
    
    [self update];
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateEveryMinute];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    self.dateTimeView.date = [NSDate date];
    [self updateTitle];
}

- (void)updateTitle
{
    NSDate *date = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSHourCalendarUnit fromDate:date];
    
    if (components.hour >= 17) { // 5pm
        self.titleLabel.text = @"Good evening!";
    } else if (components.hour >= 12) {
        self.titleLabel.text = @"Good afternoon!";
    } else {
        self.titleLabel.text = @"Good morning!";
    }
}

- (void)updateEveryMinute
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = floor([date timeIntervalSinceReferenceDate] / 60) * 60 + 60;
    date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    
    _timer = [[NSTimer alloc] initWithFireDate:date
                                      interval:60
                                        target:self
                                      selector:@selector(update)
                                      userInfo:nil
                                       repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
