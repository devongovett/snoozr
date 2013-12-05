//
//  SNBlurredViewController.h
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNDateTimeView.h"

/**
 *  Base class for a view controller with a blurred background (iOS 7 style)
 *  Includes an SNDateTimeView and a title label.
 */
@interface SNBlurredViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet SNDateTimeView *dateTimeView;

@end
