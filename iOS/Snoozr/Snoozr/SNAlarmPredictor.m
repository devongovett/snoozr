//
//  SNAlarmPredictor.m
//  Snoozr
//
//  Created by Devon Govett on 12/4/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import "SNAlarmPredictor.h"
#import "SNNeuralNet.h"

#define MIN_ERROR 0.0001
#define LEARNING_RATE 0.8
#define MAX_ITERATIONS 75000
#define MINUTES_PER_DAY 1440
#define ROUND_TIME 5
#define USER_DEFAULTS_KEY @"SNSharedAlarmPredictor"

// NSArrays can't hold C structs, so make an object to hold training records
@interface SNInputRecord : NSObject <NSCoding>

@property (nonatomic) double input;
@property (nonatomic) double output;

+ (instancetype)recordWithInput:(double)input output:(double)output;

@end

@implementation SNInputRecord

+ (instancetype)recordWithInput:(double)input output:(double)output
{
    SNInputRecord *res = [[self alloc] init];
    res.input = input;
    res.output = output;
    return res;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.input = [aDecoder decodeDoubleForKey:@"input"];
        self.output = [aDecoder decodeDoubleForKey:@"output"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.input forKey:@"input"];
    [aCoder encodeDouble:self.output forKey:@"output"];
}

@end

@interface SNAlarmPredictor ()

@property (nonatomic) SNNeuralNet *net;
@property (nonatomic) NSMutableArray *records;

@end

@implementation SNAlarmPredictor
{
    double averages[8];
    int counts[8];
}

+ (instancetype)shared
{
    static SNAlarmPredictor *shared = nil;
    if (shared != nil)
        return shared;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_KEY];
    if (data != nil) {
        shared = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        shared = [[SNAlarmPredictor alloc] init];
    }
    
    return shared;
}

- (instancetype)init
{    
    if (self = [super init]) {
        self.records = [[NSMutableArray alloc] init];
        [self initNeuralNet];
    }
    
    return self;
}

- (void)initNeuralNet
{
    self.net = [[SNNeuralNet alloc] initWithInputs:1 outputs:1];
    self.net.minError = MIN_ERROR;
    self.net.learningRate = LEARNING_RATE;
    self.net.maxIterations = MAX_ITERATIONS;
    
    if (self.records.count > 0) {
        // convert NSArray of record classes into C array of SNTrainingRecord structs
        SNTrainingRecord trainingData[self.records.count];
        
        for (int i = 0; i < self.records.count; i++) {
            SNInputRecord *record = self.records[i];
            trainingData[i].input = SNInput(record.input);
            trainingData[i].output = SNOutput(record.output);
        }
        
        [self.net train:trainingData numRecords:(int)self.records.count];
    }
}

- (void)learnAlarmTimeForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    double time = (components.hour * 60 + components.minute);

    [self.records addObject:[SNInputRecord recordWithInput:components.weekday / 7.0
                                               output:time / MINUTES_PER_DAY]];

    counts[components.weekday]++;
    averages[components.weekday] += time;
    
    [self initNeuralNet];
    [self save];
}

- (double)averageTimeForWeekday:(long)weekday
{
    if (counts[weekday] == 0)
        return -1;
    
    return averages[weekday] / counts[weekday];
}

- (NSDate *)predictAlarmTimeForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit)
                                               fromDate:date];
    
    if (counts[components.weekday] == 0) {
        // if there is no training data, just assume 8am
        components.hour = 8;
    } else {
        double *output = [self.net runInput:SNInput(components.weekday / 7.0)];
        double netOutput = *output * MINUTES_PER_DAY;
        double avg = [self averageTimeForWeekday:components.weekday];
        
        double netAvg = (netOutput + avg) / 2;
        int alarmTime = (int)netAvg;
        
        if (avg > netAvg)
            alarmTime += ROUND_TIME;
        
        if (avg != netAvg)
            alarmTime -= (alarmTime % ROUND_TIME);
        
//        printf("OUTPUT = %f, ALARM_TIME = %d, AVG = %f, NETAVG = %f\n", netOutput, alarmTime, avg, netAvg);
        
        components.hour = alarmTime / 60;
        components.minute = alarmTime % 60;
    }
    
    return [calendar dateFromComponents:components];
}

- (void)reset
{
    for (int i = 1; i <= 7; i++)
        averages[i] = counts[i] = 0;
    
    [self.records removeAllObjects];
    [self initNeuralNet];
    [self save];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.net = [decoder decodeObjectForKey:@"net"];
        self.records = [decoder decodeObjectForKey:@"records"];
        
        NSData *data = [decoder decodeObjectForKey:@"averages"];
        memcpy(averages, data.bytes, data.length);
        
        data = [decoder decodeObjectForKey:@"counts"];
        memcpy(counts, data.bytes, data.length);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.net forKey:@"net"];
    [coder encodeObject:self.records forKey:@"records"];
    [coder encodeObject:[NSData dataWithBytes:averages length:8 * sizeof(double)] forKey:@"averages"];
    [coder encodeObject:[NSData dataWithBytes:counts length:8 * sizeof(int)] forKey:@"counts"];
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_DEFAULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
