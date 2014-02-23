//
//  BillRecord.m
//  BillsBuddy
//
//  Created by Tony Zhou on 2/22/14.
//  Copyright (c) 2014 Equippd Software. All rights reserved.
//

#import "BillRecord.h"
#import "BillDate.h"
#import "BillRecurrenceRule.h"
#import "BillRecurrenceEnd.h"


@implementation BillRecord

@dynamic amount;
@dynamic category;
@dynamic item;
@dynamic nextDueDate;
@dynamic notes;
@dynamic startDate;
@dynamic overdueBills;
@dynamic paidBills;
@dynamic recurrenceRule;

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
    DLog(@"paidCurrentAndUpdateDueDate called")
    BillDate *paidDate = [NSEntityDescription
                          insertNewObjectForEntityForName:@"BillDate"
                          inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
    [paidDate setDate:[NSDate date]];
    [paidDate setPaidRecord:self];
    [self updateOccurences];
    [self updateDueDate];
    [APP_DELEGATE saveContext];
}

- (void)overdueCurrentAndUpdateDueDate {
    DLog(@"overdueCurrentAndUpdateDueDate called")
    BillDate *overdueDate = [NSEntityDescription
                             insertNewObjectForEntityForName:@"BillDate"
                             inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
    [overdueDate setDate:self.nextDueDate];
    [overdueDate setOverdueRecord:self];
    [self updateOccurences];
    [self updateDueDate];
    [APP_DELEGATE saveContext];
}

- (void)updateOccurences {
    if (self.recurrenceRule != nil ) {
        if (self.recurrenceRule.recurrenceEnd) {
            DAssert((self.recurrenceRule.recurrenceEnd.occurenceCount == 0) ||  (self.recurrenceRule.recurrenceEnd.endDate==nil), @"cannot have recurrenceEnd with both cound and end date set!")
            if (self.recurrenceRule.recurrenceEnd.occurenceCount.intValue > 0) // decrement occurence count
                self.recurrenceRule.recurrenceEnd.occurenceCount = [NSNumber numberWithInt:((int)self.recurrenceRule.recurrenceEnd.occurenceCount.intValue-1)];
            
            if ((self.recurrenceRule.recurrenceEnd.endDate != nil && [BBMethodStore daysBetween:[NSDate date] and:self.recurrenceRule.recurrenceEnd.endDate] < 0) ||
                (self.recurrenceRule.recurrenceEnd.occurenceCount == 0)){ // no more due dates to meet, or no more occurences left
                self.recurrenceRule.recurrenceEnd.endDate = nil;
                self.recurrenceRule.recurrenceEnd.occurenceCount = [NSNumber numberWithInt:0];
            }
        }
    } // use occurenceCount = 0 to indicate no more occurences
}

- (void)updateDueDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSDate *prevDueDate = self.nextDueDate;
    NSDate *calcDueDate;
    self.nextDueDate = nil;
    if (self.recurrenceRule != nil && [self hasOccurences]) {
        DAssert(self.recurrenceRule.frequency!=nil, @"cannot updateDueDate with recurrenceRule without frequency")
        DAssert(self.recurrenceRule.interval!=nil, @"cannot updateDueDate with recurrenceRule without interval")
        BBRecurrenceFrequency freq = self.recurrenceRule.frequency.intValue;
        int interval = self.recurrenceRule.interval.intValue;
        switch (freq) {
            case BBRecurrenceFrequencyDaily:
                components.day = 1 * interval;
                break;
            case BBRecurrenceFrequencyWeekly:
                components.day = 7 * interval;
                break;
            case BBRecurrenceFrequencyMonthly:
                components.month = 1 * interval;
                break;
            case BBRecurrenceFrequencyYearly:
                components.year = 1 * interval;
            default:
                DAssert(0, @"invalid BBRecurrenceFrequency type")
                break;
        }
        calcDueDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:prevDueDate options:0];
    }
    if (self.recurrenceRule.recurrenceEnd != nil && self.recurrenceRule.recurrenceEnd.endDate != nil &&
        [BBMethodStore daysBetween:calcDueDate and:self.recurrenceRule.recurrenceEnd.endDate] < 0) // endDate already past
        calcDueDate = nil;
    
    self.nextDueDate = calcDueDate;
}

- (BOOL)hasOccurences {
    return (self.recurrenceRule.recurrenceEnd==nil || self.recurrenceRule.recurrenceEnd.occurenceCount.intValue>0);
}

- (BOOL)hasDueDate {
    return (self.nextDueDate != nil);
}

- (BOOL)hasPaidBills {
    int paid = (int)[self.paidBills count];
    return (paid!=0);
}

- (BOOL)hasOverdueBills {
    int overdue = (int)[self.overdueBills count];
    return (overdue!=0);
}

- (NSDate *)recentPaidDate {
    DAssert(self.paidBills!=nil && self.paidBills.count>0, @"cannot call this method without a valid paidBills set")
    BillDate *recent = [self.paidBills objectAtIndex:self.paidBills.count-1];
    return recent.date;
}

- (NSDate *)recentOverdueDate {
    DAssert(self.overdueBills!=nil && self.overdueBills.count>0, @"cannot call this method without a valid overdueBills set")
    BillDate *recent = [self.overdueBills objectAtIndex:self.overdueBills.count-1];
    return recent.date;
}

@end
