//
//  SNViewController.h
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNBlurredViewController.h"

/**
 *  The view controller for the main screen of the app, for setting the alarm
 *  Uses a gesture recognizer to handle touch events as the user swipes on the screen
 *  to set the alarm. Swiping on the left changes the date faster than on the right.
 *  Includes buttons to go to settings, and to go to sleep, which schedules the alarm after
 *  adjusting for the user's sleep cycles. User can also swipe left to right over the date
 *  to see additional settings, to enable/disable the alarm and enable/disable learning.
 */
@interface SNViewController : SNBlurredViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
