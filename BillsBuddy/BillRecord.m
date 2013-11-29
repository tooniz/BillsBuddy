//
//  BillRecord.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/28/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BillRecord.h"
#import "BillDate.h"
#import "BillRecurrenceRule.h"


@implementation BillRecord

@dynamic amount;
@dynamic date;
@dynamic item;
@dynamic notes;
@dynamic overdueBills;
@dynamic paidBills;
@dynamic recurrenceRule;

/*
 + (id)disconnectedEntity;
 - (void)addToContext:(NSManagedObjectContext *)context;
 - (void)paidCurrentAndUpdateDueDate;
 - (BOOL)hasDueDate;
 - (BOOL)hasPaidBills;
 - (BOOL)hasOverdueBills;
 */

+ (id)disconnectedEntity {
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BillRecord" inManagedObjectContext:context];
    return (BillRecord *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
    for (BillDate *date in self.overdueBills)
        [date addToContext:context];
    for (BillDate *date in self.paidBills)
        [date addToContext:context];
    [self.recurrenceRule addToContext:context];
}

- (void)paidCurrentAndUpdateDueDate {
    BillDate *paidDate = [NSEntityDescription
                          insertNewObjectForEntityForName:@"BillDate"
                          inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
    [paidDate setDate:[NSDate date]];
    [paidDate setPaidRecord:self];
    int freq = self.recurrenceRule.frequency.intValue;
    if (freq > 0) {
        freq --;
        [self.recurrenceRule setFrequency:[NSNumber numberWithInt:freq]];
    }
    [APP_DELEGATE saveContext];
}

- (BOOL)hasDueDate {
    int freq = self.recurrenceRule.frequency.intValue;
    return (freq!=0);
}

- (BOOL)hasPaidBills {
    int paid = (int)[self.paidBills count];
    return (paid!=0);
}

- (BOOL)hasOverdueBills {
    int overdue = (int)[self.overdueBills count];
    return (overdue!=0);
}

@end
