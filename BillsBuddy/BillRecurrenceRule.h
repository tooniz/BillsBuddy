//
//  BillRecurrenceRule.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/29/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRecord, BillRecurrenceEnd, MonthDays, Positions, WeekDays, YearDays, YearMonths, YearWeeks;

@interface BillRecurrenceRule : NSManagedObject

@property (nonatomic, retain) NSString * calendarIdentifier;
@property (nonatomic, retain) NSNumber * firstDayOfTheWeek;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSSet *daysOfTheMonth;
@property (nonatomic, retain) NSSet *daysOfTheWeek;
@property (nonatomic, retain) NSSet *daysOfTheYear;
@property (nonatomic, retain) NSSet *monthsOfTheYear;
@property (nonatomic, retain) BillRecord *record;
@property (nonatomic, retain) NSSet *setPositions;
@property (nonatomic, retain) NSSet *weeksOfTheYear;
@property (nonatomic, retain) BillRecurrenceEnd *recurrenceEnd;
@end

@interface BillRecurrenceRule (CoreDataGeneratedAccessors)

- (void)addDaysOfTheMonthObject:(MonthDays *)value;
- (void)removeDaysOfTheMonthObject:(MonthDays *)value;
- (void)addDaysOfTheMonth:(NSSet *)values;
- (void)removeDaysOfTheMonth:(NSSet *)values;

- (void)addDaysOfTheWeekObject:(WeekDays *)value;
- (void)removeDaysOfTheWeekObject:(WeekDays *)value;
- (void)addDaysOfTheWeek:(NSSet *)values;
- (void)removeDaysOfTheWeek:(NSSet *)values;

- (void)addDaysOfTheYearObject:(YearDays *)value;
- (void)removeDaysOfTheYearObject:(YearDays *)value;
- (void)addDaysOfTheYear:(NSSet *)values;
- (void)removeDaysOfTheYear:(NSSet *)values;

- (void)addMonthsOfTheYearObject:(YearMonths *)value;
- (void)removeMonthsOfTheYearObject:(YearMonths *)value;
- (void)addMonthsOfTheYear:(NSSet *)values;
- (void)removeMonthsOfTheYear:(NSSet *)values;

- (void)addSetPositionsObject:(Positions *)value;
- (void)removeSetPositionsObject:(Positions *)value;
- (void)addSetPositions:(NSSet *)values;
- (void)removeSetPositions:(NSSet *)values;

- (void)addWeeksOfTheYearObject:(YearWeeks *)value;
- (void)removeWeeksOfTheYearObject:(YearWeeks *)value;
- (void)addWeeksOfTheYear:(NSSet *)values;
- (void)removeWeeksOfTheYear:(NSSet *)values;

+ (id)disconnectedEntity;
- (void)addToContext:(NSManagedObjectContext *)context;

@end
