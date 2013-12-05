//
//  SNDateTimeView.h
//  Snoozr
//
//  Created by Devon Govett on 10/20/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Displays a date on screen, including time and date
 *  Formats it to look nice using attributed strings.
 */
@interface SNDateTimeView : UIView

/**
 *  The date to display
 */
@property (nonatomic, copy) NSDate *date;

@end
