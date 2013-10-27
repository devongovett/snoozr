//
//  SNSound.h
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SNSound : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;

- (id)initWithName:(NSString *)name filename:(NSString *)filename;
+ (SNSound *)defaultSound;

- (void)play;
+ (void)stop;
+ (BOOL)isPlaying;

@end
