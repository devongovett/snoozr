//
//  SNViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNViewController.h"

@interface SNViewController ()

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"background.jpg"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[image applyDarkEffect]];
    [self.view insertSubview:imageView atIndex:0];

    self.view.tintColor = [UIColor whiteColor];
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.dateLabel.textColor = [UIColor whiteColor];

    [self updateTime];
    [self updateDate];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)updateTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[formatter stringFromDate:date]];
    
    UIFont *timeFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    UIFont *colonFont = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:110];
    UIFont *amPmFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
    NSRange colonRange = [string.string rangeOfString:@":"];
    
    [string addAttribute:NSFontAttributeName value:timeFont range:NSMakeRange(0, string.length - 3)];
    [string addAttribute:NSFontAttributeName value:amPmFont range:NSMakeRange(string.length - 3, 3)];
    [string addAttribute:NSFontAttributeName value:colonFont range:colonRange];
    [string addAttribute:NSBaselineOffsetAttributeName value:@12 range:colonRange];

    self.timeLabel.attributedText = string;
}

- (void)updateDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterFullStyle;
    
    self.dateLabel.text = [formatter stringFromDate:date];
}

@end
