//
//  MonthDays.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "MonthDays.h"
#import "BillRecurrenceRule.h"


@implementation MonthDays

@dynamic day;
@dynamic recurrenceRule;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
