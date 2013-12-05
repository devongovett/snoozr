//
//  SnoozrTests.m
//  SnoozrTests
//
//  Created by Devon Govett on 10/13/13.
//  Copyright (c) 2013 Snoozr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SNAlarmPredictor.h"
#import "NSDate+Snoozr.h"

@interface SnoozrTests : XCTestCase

@end

@implementation SnoozrTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSDate *)dateWithWeekday:(int)weekday hours:(int)hours minutes:(int)minutes
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit) fromDate:[NSDate date]];
    components.weekday = weekday;
    components.week++;
    components.hour = hours;
    components.minute = minutes;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)testAlarmPredictor
{
    SNAlarmPredictor *predictor = [[SNAlarmPredictor alloc] init];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:2 hours:8 minutes:30]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:3 hours:9 minutes:00]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:4 hours:10 minutes:30]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:5 hours:8 minutes:30]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:6 hours:9 minutes:30]];
    
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:2 hours:8 minutes:45]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:3 hours:9 minutes:30]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:4 hours:10 minutes:00]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:5 hours:8 minutes:20]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:6 hours:9 minutes:45]];
    
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:2 hours:8 minutes:45]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:3 hours:9 minutes:30]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:4 hours:10 minutes:00]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:5 hours:8 minutes:20]];
    [predictor learnAlarmTimeForDate:[self dateWithWeekday:6 hours:9 minutes:45]];

//    NSDate *date = [predictor predictAlarmTimeForDate:[NSDate date]];
//    NSDate *date = [predictor predictAlarmTimeForDate:[self dateWithWeekday:7 hours:0 minutes:0]];
    NSDate *date = [predictor predictAlarmTimeForDate:[NSDate tomorrow]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterFullStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSLog(@"%@", [formatter stringFromDate:date]);
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:predictor];
//    NSLog(@"data length = %d", data.length);
}

@end
