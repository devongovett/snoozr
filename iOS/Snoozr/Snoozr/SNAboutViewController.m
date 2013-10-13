//
//  SNAboutViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNAboutViewController.h"

@interface SNAboutViewController ()

@end

@implementation SNAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html" inDirectory:nil];
    NSString* htmlString = [NSString stringWithContentsOfFile:aboutPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
