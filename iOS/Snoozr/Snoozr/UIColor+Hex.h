//
//  UIColor+Hex.h
//  amount.io
//
//  Created by Devon Govett on 8/15/13.
//  Copyright (c) 2013 Devon Govett. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Some additions to UIColor that make it easier to work with.
 */
@interface UIColor (Hex)

/**
 *  Creates a color from an RGB hex value
 *
 *  @param hex RGB hex value
 *  @return UIColor for the input hex value
 */
+ (UIColor *) colorWithHex:(UInt32)hex;

/**
 *  Darkens a color by a given amount
 *
 *  @param amount Amount to darken
 *  @return New darkened UIColor
 */
- (UIColor *) darken:(double)amount;

@end
