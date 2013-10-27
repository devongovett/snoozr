//
//  SNSoundViewController.m
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNSoundViewController.h"
#import "SNSettings.h"

@implementation SNSoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sounds = @[
        [[SNSound alloc] initWithName:@"Alarm" filename:@"alarm_clock_ringing.wav"],
        [[SNSound alloc] initWithName:@"Church Bells" filename:@"church_bells.wav"],
        [[SNSound alloc] initWithName:@"Beep" filename:@"card_reader_alarm.wav"],
        [[SNSound alloc] initWithName:@"Police" filename:@"police.wav"]
    ];
    
    _selectedSound = [SNSettings alarmSound];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [SNSound stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SNSound *sound = self.sounds[indexPath.row];
    cell.textLabel.text = sound.name;
    cell.accessoryType = [sound isEqual:self.selectedSound] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SNSound *sound = self.sounds[indexPath.row];
    if ([sound isEqual:self.selectedSound] && [SNSound isPlaying]) {
        [SNSound stop];
    } else {
        [sound play];
        _selectedSound = sound;
        [SNSettings setAlarmSound:sound];
        [self.tableView reloadData];
    }
}

@end
