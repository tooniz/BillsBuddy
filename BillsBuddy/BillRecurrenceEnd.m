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

+ (id)disconnectedEntity {
    NSManagedObjectContext *context = [APP_DELEGATE managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BillRecurrenceEnd" inManagedObjectContext:context];
    return (BillRecord *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
