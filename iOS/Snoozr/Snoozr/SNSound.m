//
//  SNSound.m
//  Snoozr
//
//  Created by Devon Govett on 10/26/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNSound.h"

static SystemSoundID _soundID;
static BOOL isPlaying = NO;

static void completionCallback(SystemSoundID soundID, void *data) {
    AudioServicesDisposeSystemSoundID(soundID);
    isPlaying = NO;
}

@implementation SNSound

- (id)initWithName:(NSString *)name filename:(NSString *)filename
{
    self = [self init];
    
    if (self) {
        self.name = name;
        self.filename = filename;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *filename = [aDecoder decodeObjectForKey:@"filename"];
    return [self initWithName:name filename:filename];
}

+ (SNSound *)defaultSound
{
    return [[SNSound alloc] initWithName:@"Alarm" filename:@"alarm_clock_ringing.wav"];
}

- (void)play
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.filename withExtension:nil];
    
    [SNSound stop];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &_soundID);
    AudioServicesPlayAlertSound(_soundID);
    AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, &completionCallback, NULL);
    isPlaying = YES;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    
    if (!object || ![object isKindOfClass:[self class]])
        return NO;
    
    SNSound *other = object;
    return [self.name isEqualToString:other.name] && [self.filename isEqualToString:other.filename];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.filename forKey:@"filename"];
}

+ (void)stop
{
    if (_soundID)
        AudioServicesDisposeSystemSoundID(_soundID);
    
    isPlaying = NO;
}

+ (BOOL)isPlaying
{
    return isPlaying;
}

@end
