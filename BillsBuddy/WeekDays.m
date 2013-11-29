//
//  WeekDays.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "WeekDays.h"
#import "BillRecurrenceRule.h"


@implementation WeekDays

@dynamic day;
@dynamic week;
@dynamic recurrenceRule;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
