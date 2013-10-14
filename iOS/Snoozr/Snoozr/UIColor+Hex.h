//
//  UIColor+Hex.h
//  amount.io
//
//  Created by Devon Govett on 8/15/13.
//  Copyright (c) 2013 Devon Govett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *) colorWithHex:(UInt32)hex;
- (UIColor *) darken:(double)amount;

@end
