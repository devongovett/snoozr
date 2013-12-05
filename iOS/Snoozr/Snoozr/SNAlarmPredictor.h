//
//  SNAlarmPredictor.h
//  Snoozr
//
//  Created by Devon Govett on 12/4/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class manages a neural network to learn and predict alarm times
@interface SNAlarmPredictor : NSObject <NSCoding>

+ (instancetype)shared;

- (void)learnAlarmTimeForDate:(NSDate *)date;
- (NSDate *)predictAlarmTimeForDate:(NSDate *)date;
- (void)reset;

@end
