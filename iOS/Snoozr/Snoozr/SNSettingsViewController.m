//
//  SNSettingsViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNSettingsViewController.h"

@interface SNSettingsViewController ()

@end

@implementation SNSettingsViewController
{
    NSDictionary *_data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(dismiss);
    
    _data = @{
       @"Settings": @[@{
           @"text": @"Number of Allowed Snoozes",
           @"detail": @"5"
       }, @{
           @"text": @"Sleep Cycle",
           @"detail": @"90 minutes"
       }, @{
           @"text": @"Sound",
           @"detail": @"Alarm"
       }],
       @"About": @[@{
           @"cell": @"InfoCell",
           @"text": @"Version",
           @"detail": @"0.0.1"
       }, @{
           @"cell": @"AboutCell",
           @"text": @"About"
       }],
       @"Danger Zone": @[@{
           @"cell": @"ResetCell",
           @"text": @"Reset Schedule",
           @"footer": @"Copyright © 2013 Snoozr"
       }]
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *items = _data[[_data allKeys][section]];
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_data allKeys][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *row = _data[[_data allKeys][indexPath.section]][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row[@"cell"] ? row[@"cell"] : @"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = row[@"text"];
    if (row[@"detail"])
        cell.detailTextLabel.text = row[@"detail"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSArray *items = _data[[_data allKeys][section]];
    return [items lastObject][@"footer"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if (indexPath.section == 2) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset your schedule?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Reset Schedule"
                                                  otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset complete"
                                   message:@"This is not really what will be here."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
