//
//  UIDate+Greeting.h
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//



@interface NSDate (Greeting)

@property (readonly) NSString *greeting;

- (NSDate *)dateRoundedToMinutes;

+ (NSDate *)tomorrow;

@end
