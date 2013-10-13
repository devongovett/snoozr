//
//  UIColor+Hex.m
//  amount.io
//
//  Created by Devon Govett on 8/15/13.
//  Copyright (c) 2013 Devon Govett. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *) colorWithHex:(UInt32)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:1.0];
}

@end
