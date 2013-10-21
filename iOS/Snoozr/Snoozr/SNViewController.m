//
//  SNViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNViewController.h"

@implementation SNViewController
{
    NSDate *_startDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:recognizer];
    
    self.statusLabel.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)sectionForPoint:(CGPoint)point
{
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float sectionWidth = screenWidth / 3;
    return point.x / sectionWidth + 1;
}

- (void)updateStatusForSection:(int)section
{
    switch (section) {
        case 1:
            self.statusLabel.text = @"High speed scrubbing";
            break;
        case 2:
            self.statusLabel.text = @"Medium speed scrubbing";
            break;
        case 3:
            self.statusLabel.text = @"Low speed scrubbing";
            break;
        default:
            self.statusLabel.text = @"Swipe to set alarm";
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    int section = [self sectionForPoint:point];
    [self updateStatusForSection:section];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateStatusForSection:0];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self updateStatusForSection:0];
    } else {
        CGPoint location = [recognizer locationInView:self.view];
        int section = [self sectionForPoint:location];
    
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            _startDate = [self.dateTimeView.date copy];
        }  else {
            CGPoint translatedPoint = [recognizer translationInView:self.view];
            int sectionInverse = 3 - section + 1;
            int velocity = sectionInverse * sectionInverse * 7;
            self.dateTimeView.date = [_startDate dateByAddingTimeInterval:translatedPoint.y * velocity];
        }
        
        [self updateStatusForSection:section];
    }
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    
    if (sender.on) {
        self.dateTimeView.alpha = 1.0;
    } else {
        self.dateTimeView.alpha = 0.5;
    }
    
    [UIView commitAnimations];
}

@end
