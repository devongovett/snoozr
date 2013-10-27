//
//  SNSettingsViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNSettingsViewController.h"
#import "SNSoundViewController.h"
#import "SNSettings.h"

@implementation SNSettingsViewController
{
    NSDictionary *_data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(dismiss);
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"SNSettingsChanged" object:nil];
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
    switch (indexPath.section) {
        case 0:
            [self showSettingsForRow:indexPath.row];
            break;
        case 1:
            if (indexPath.row == 0)
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case 2:
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self resetSchedule];
            break;
    }
}

- (void)showSettingsForRow:(NSInteger)row
{
    if (row == 2) {
        SNSoundViewController *soundPicker = (SNSoundViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SNSoundViewController"];
        [self.navigationController pushViewController:soundPicker animated:YES];
    }
}

- (void)resetSchedule
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to reset your schedule?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Reset Schedule"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];

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

- (void)reloadData
{
    _data = @{
       @"Settings": @[@{
           @"text": @"Number of Allowed Snoozes",
           @"detail": [NSString stringWithFormat:@"%ld", [SNSettings numSnoozes]]
       }, @{
           @"text": @"Sleep Cycle",
           @"detail": [NSString stringWithFormat:@"%ld minutes", [SNSettings sleepCycle]]
       }, @{
           @"text": @"Sound",
           @"detail": [SNSettings alarmSound].name
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

    [self.tableView reloadData];
}

@end
