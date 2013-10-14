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
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateHighlighted];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setHighlighted:self.highlighted];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.layer.backgroundColor = [[self.backgroundColor darken:0.15] CGColor];
    } else {
        self.layer.backgroundColor = [self.backgroundColor CGColor];
    }
}

@end
