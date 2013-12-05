//
//  SNWakeViewController.h
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNButton.h"
#import "SNBlurredViewController.h"
#import "SNAlarm.h"

/**
 *  The view displayed to the user when they wake up. Includes
 *  current time, and dismiss and snooze buttons. When the alarm is
 *  dismissed, triggers learning in the SNAlarmPredictor for the current
 *  alarm.
 */
@interface SNWakeViewController : SNBlurredViewController

@property (weak, nonatomic) IBOutlet SNButton *dismissButton;
@property (weak, nonatomic) IBOutlet SNButton *snoozeButton;
@property (nonatomic) SNAlarm *alarm;

@end
