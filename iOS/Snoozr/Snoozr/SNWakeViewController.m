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

@implementation SNWakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton.backgroundColor = [UIColor colorWithHex:0xBF2E2D];
    self.snoozeButton.backgroundColor = [UIColor colorWithHex:0x42C54F];
    
    [self updateTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
