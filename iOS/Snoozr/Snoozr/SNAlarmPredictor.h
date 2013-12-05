//
//  SNAlarmPredictor.h
//  Snoozr
//
//  Created by Devon Govett on 12/4/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class manages a neural network to learn and predict alarm times.
 *  It handles conversion between NSDates and the internal neural network
 *  format, rounds and adjusts the neural network output, persists training
 *  data and neural network, and allows resetting the schedule.
 */
@interface SNAlarmPredictor : NSObject <NSCoding>

/**
 *  Returns a shared instance of this class.
 *
 *  @return shared instance
 */
+ (instancetype)shared;

/**
 *  Adds a new date to the training data for the neural network.
 *
 *  @param date Date to add to neural net
 */
- (void)learnAlarmTimeForDate:(NSDate *)date;

/**
 *  Predicts the wake up time for a given weekday, represented by
 *  an NSDate.
 *
 *  @param date Date to predict wake up time for
 *  @return Predicted wake up time
 */
- (NSDate *)predictAlarmTimeForDate:(NSDate *)date;

/**
 *  Resets the neural network and everything else about the schedule.
 */
- (void)reset;

@end
