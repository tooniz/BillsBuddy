//
//  BillRecurrenceEnd.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/29/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRecurrenceRule;

@interface BillRecurrenceEnd : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * occurenceCount;
@property (nonatomic, retain) BillRecurrenceRule *rule;

- (void)addToContext:(NSManagedObjectContext *)context;

@end
