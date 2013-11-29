//
//  BillRecurrenceEnd.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/29/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BillRecurrenceEnd.h"
#import "BillRecurrenceRule.h"


@implementation BillRecurrenceEnd

@dynamic endDate;
@dynamic occurenceCount;
@dynamic rule;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
