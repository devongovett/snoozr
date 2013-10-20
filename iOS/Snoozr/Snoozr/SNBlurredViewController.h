//
//  SNBlurredViewController.h
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNDateTimeView.h"

@interface SNBlurredViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet SNDateTimeView *dateTimeView;

@end
