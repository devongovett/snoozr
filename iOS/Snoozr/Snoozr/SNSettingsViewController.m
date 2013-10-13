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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(dismiss);
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
    switch (section) {
        case 0:
        case 1: return 2;
        case 2: return 1;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Settings";
        case 1: return @"About";
        case 2: return @"Danger Zone";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Number of Allowed Snoozes";
                cell.detailTextLabel.text = @"5";
                break;
            case 1:
                cell.textLabel.text = @"Sleep Cycle";
                cell.detailTextLabel.text = @"90 minutes";
                break;
                
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell" forIndexPath:indexPath];
                cell.textLabel.text = @"Version";
                cell.detailTextLabel.text = @"0.0.1";
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
                cell.textLabel.text = @"About";
                break;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResetCell" forIndexPath:indexPath];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return section == 2 ? @"Copyright © 2013 Snoozr" : nil;
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
