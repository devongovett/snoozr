//
//  SNSoundViewController.h
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSound.h"

/**
 *  Shows the list of sounds to the user to pick from. Plays the sound
 *  when the user selects it. Tapping again stops the sound.
 */
@interface SNSoundViewController : UITableViewController

@property (nonatomic, copy) NSArray *sounds;
@property (readonly) SNSound *selectedSound;
@property (nonatomic, weak) id delegate;

@end
