//
//  BillDate.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/28/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BillDate.h"
#import "BillRecord.h"


@implementation BillDate

@dynamic date;
@dynamic overdueRecord;
@dynamic paidRecord;

- (void)addToContext:(NSManagedObjectContext *)context {
    [context insertObject:self];
}

@end
