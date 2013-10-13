//
//  SNButton.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNButton.h"
#import "UIColor+Hex.h"

@implementation SNButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.layer.backgroundColor = [backgroundColor CGColor];
}

@end
