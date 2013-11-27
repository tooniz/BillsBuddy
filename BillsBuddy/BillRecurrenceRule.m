//
//  BillRecurrenceRule.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BillRecurrenceRule.h"
#import "BillRecord.h"
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
@dynamic recurrenceEnd;
@dynamic daysOfTheMonth;
@dynamic daysOfTheWeek;
@dynamic daysOfTheYear;
@dynamic monthsOfTheYear;
@dynamic weeksOfTheYear;
@dynamic setPositions;
@dynamic record;

@end
