//
//  SNAlarm.h
//  Snoozr
//
//  Created by Devon Govett on 10/27/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAlarm : NSObject

@property (nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL enabled;

- (void)cancel;
- (void)schedule;

@end
