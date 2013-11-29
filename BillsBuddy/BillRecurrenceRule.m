//
//  BillRecurrenceRule.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/29/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BillRecurrenceRule.h"
#import "BillRecord.h"
#import "BillRecurrenceEnd.h"
#import "MonthDays.h"
#import "Positions.h"
#import "WeekDays.h"
#import "YearDays.h"
#import "YearMonths.h"
#import "YearWeeks.h"


@implementation BillRecurrenceRule

@dynamic calendarIdentifier;
@dynamic firstDayOfTheWeek;
@dynamic frequency;
@dynamic interval;
@dynamic daysOfTheMonth;
@dynamic daysOfTheWeek;
@dynamic daysOfTheYear;
@dynamic monthsOfTheYear;
@dynamic record;
@dynamic setPositions;
@dynamic weeksOfTheYear;
@dynamic recurrenceEnd;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
    for (WeekDays *wd in self.daysOfTheWeek)
        [wd addToContext:context];
    for (MonthDays *md in self.daysOfTheMonth)
        [md addToContext:context];
    for (YearDays *yd in self.daysOfTheYear)
        [yd addToContext:context];
    for (YearMonths *ym in self.monthsOfTheYear)
        [ym addToContext:context];
    for (YearWeeks *yw in self.weeksOfTheYear)
        [yw addToContext:context];
    for (Positions *pos in self.setPositions)
        [pos addToContext:context];
    [self.recurrenceEnd addToContext:context];
}

@end
