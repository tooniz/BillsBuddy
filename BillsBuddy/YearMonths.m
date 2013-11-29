//
//  YearMonths.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "YearMonths.h"
#import "BillRecurrenceRule.h"


@implementation YearMonths

@dynamic month;
@dynamic recurrenceRule;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
