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

@interface SNWakeViewController : SNBlurredViewController

@property (weak, nonatomic) IBOutlet SNButton *dismissButton;
@property (weak, nonatomic) IBOutlet SNButton *snoozeButton;

@end
