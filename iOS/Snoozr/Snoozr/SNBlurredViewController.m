//
//  SNBlurredViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNBlurredViewController.h"
#import "UIImage+ImageEffects.h"

@implementation SNBlurredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"background.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image applyDarkEffect]];
    [self.view insertSubview:imageView atIndex:0];
    
    self.view.tintColor = [UIColor whiteColor];
    self.titleLabel.textColor = self.view.tintColor;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
