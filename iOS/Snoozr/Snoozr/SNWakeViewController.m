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
#import "SNSettings.h"
#import "NSDate+Snoozr.h"
#import "SNAlarmPredictor.h"

@implementation SNWakeViewController
{
    NSTimer *_timer;
    NSInteger numSnoozes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton.backgroundColor = [UIColor colorWithHex:0x42C54F];
    self.snoozeButton.backgroundColor = [UIColor colorWithHex:0xBF2E2D];
    
    [self update];
    [self.snoozeButton addTarget:self action:@selector(snooze) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateEveryMinute];
    [[SNSettings alarmSound] play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    [SNSound stop];
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
    self.titleLabel.text = [[NSDate date] greeting];
}

- (void)updateEveryMinute
{
    NSDate *date = [[[NSDate date] dateRoundedToMinutes] dateByAddingTimeInterval:60];
    
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
    [self.alarm cancel];
    
    // Learn from the alarm time, unless the user selected not to learn
    if (self.alarm.learn)
        [[SNAlarmPredictor shared] learnAlarmTimeForDate:self.alarm.date];
    
}

- (void)snooze
{
    [self.snoozeButton setTitle:[NSString stringWithFormat:@"Snooze (%ld)", ++numSnoozes] forState:UIControlStateNormal];
    [SNSound stop];
    
    if (numSnoozes > [SNSettings numSnoozes])
        self.snoozeButton.enabled = NO;
}

@end
