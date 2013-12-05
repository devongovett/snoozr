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
#import "UIColor+Hex.h"
#import "SNAlarmPredictor.h"

#define PICKER_TAG 99

@implementation SNSettingsViewController
{
    NSDictionary *_data;
    NSIndexPath *_pickerIndexPath;
    NSInteger _pickerCellRowHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem.target = self;
    self.navigationItem.rightBarButtonItem.action = @selector(dismiss);
    
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:@"PickerCell"];
    _pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"SNSettingsChanged" object:nil];
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
           @"detail": [SNSettings alarmSound].name,
           @"accessory": @YES
       }],
       @"About": @[@{
           @"cell": @"InfoCell",
           @"text": @"Version",
           @"detail": @"0.0.1"
       }, @{
           @"cell": @"AboutCell",
           @"text": @"About",
       }],
       @"Danger Zone": @[@{
           @"cell": @"ResetCell",
           @"text": @"Reset Schedule",
           @"footer": @"Copyright © 2013 Snoozr"
       }]
    };

    [self.tableView reloadData];
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
    NSInteger count = items.count;
    if (_pickerIndexPath != nil && _pickerIndexPath.section == section)
        count++;
    
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_data allKeys][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if  ([_pickerIndexPath isEqual:indexPath]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
        UIPickerView *picker = (UIPickerView *)[cell viewWithTag:PICKER_TAG];
        picker.delegate = self;
        
        if (_pickerIndexPath.row - 1 == 0)
            [picker selectRow:[SNSettings numSnoozes] - 1 inComponent:0 animated:NO];
        else
            [picker selectRow:([SNSettings sleepCycle] - 60) / 10 inComponent:0 animated:NO];
        
        return cell;
    }
    
    NSInteger rowIndex = indexPath.row;
    if (_pickerIndexPath != nil && indexPath.section == _pickerIndexPath.section && _pickerIndexPath.row < indexPath.row)
        rowIndex--;
    
    NSDictionary *row = _data[[_data allKeys][indexPath.section]][rowIndex];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:row[@"cell"] ? row[@"cell"] : @"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = row[@"text"];
    if (row[@"detail"])
        cell.detailTextLabel.text = row[@"detail"];
    
    if (row[@"accessory"])
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSArray *items = _data[[_data allKeys][section]];
    return [items lastObject][@"footer"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([_pickerIndexPath isEqual:indexPath] ? _pickerCellRowHeight : self.tableView.rowHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self showSettingsForRow:indexPath];
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

- (void)showSettingsForRow:(NSIndexPath *)indexPath
{
    NSInteger row = _pickerIndexPath ? indexPath.row - 1 : indexPath.row;
    
    if (row == 2) {
        SNSoundViewController *soundPicker = (SNSoundViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SNSoundViewController"];
        [self.navigationController pushViewController:soundPicker animated:YES];
    } else {
        [self showPickerBelowRow:indexPath];
    }
}

- (void)showPickerBelowRow:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if (_pickerIndexPath != nil) {
        before = _pickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (_pickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if (_pickerIndexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_pickerIndexPath.row - 1 inSection:0]];
        cell.detailTextLabel.textColor = [UIColor grayColor];

        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_pickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        _pickerIndexPath = nil;
    }
    
    if (!sameCellClicked) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        cell.detailTextLabel.textColor = self.tableView.window.tintColor;
        
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self togglePickerForSelectedIndexPath:indexPathToReveal];
        _pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.tableView endUpdates];
}

- (void)togglePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkPickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIPickerView *checkPicker = (UIPickerView *)[checkPickerCell viewWithTag:PICKER_TAG];
    
    return checkPicker != nil;
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
        [[SNAlarmPredictor shared] reset];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickerIndexPath.row - 1 == 0)
        return 10;
    else
        return 6;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerIndexPath.row -1 == 0)
        return [NSString stringWithFormat:@"%ld", row + 1];
    else
        return [NSString stringWithFormat:@"%ld minutes", row * 10 + 60];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickerIndexPath.row - 1 == 0)
        [SNSettings setNumSnoozes:row + 1];
    else
        [SNSettings setSleepCycle:row * 10 + 60];
}

@end
