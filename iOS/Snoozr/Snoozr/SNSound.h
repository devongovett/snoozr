//
//  SNSound.h
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

/**
 *  Represents a sound to play back when the alarm goes off.
 */
@interface SNSound : NSObject<NSCoding>

/**
 *  Display name for this sound
 */
@property (nonatomic, copy) NSString *name;

/**
 *  Filename of WAV file to play. Must be in application bundle.
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  Creates a new SNSound
 *
 *  @param name     Display name for the sound
 *  @param filename Filename of WAV to play in app bundle
 *
 *  @return SNSound with the above settings
 */
- (id)initWithName:(NSString *)name filename:(NSString *)filename;

/**
 *  Returns the default sound object
 *
 *  @return Default sound
 */
+ (SNSound *)defaultSound;

/**
 *  Plays the sound
 */
- (void)play;

/**
 *  Stops the sound if it is playing
 */
+ (void)stop;

/**
 *  Returns whether the sound is playing
 *
 *  @return Whether the sound is playing
 */
+ (BOOL)isPlaying;

@end
