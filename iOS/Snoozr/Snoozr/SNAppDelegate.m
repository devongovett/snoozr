//
//  SNAppDelegate.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNAppDelegate.h"
#import "SNWakeViewController.h"

@implementation SNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

/**
 *  Handles local notifications, and displays wake up view
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIViewController *root = self.window.rootViewController;
    UIStoryboard *storyboard = root.storyboard;
    SNWakeViewController *wakeView = (SNWakeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"wakeView"];
    wakeView.alarm = [NSKeyedUnarchiver unarchiveObjectWithData:notification.userInfo[@"SNAlarm"]];
    [root presentViewController:wakeView animated:YES completion:nil];
}

@end
