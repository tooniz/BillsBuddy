//
//  BillRecord.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/29/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillDate, BillRecurrenceRule;

@interface BillRecord : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSDate * nextDueDate;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSOrderedSet *overdueBills;
@property (nonatomic, retain) NSOrderedSet *paidBills;
@property (nonatomic, retain) BillRecurrenceRule *recurrenceRule;
@end

@interface BillRecord (CoreDataGeneratedAccessors)

- (void)insertObject:(BillDate *)value inOverdueBillsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOverdueBillsAtIndex:(NSUInteger)idx;
- (void)insertOverdueBills:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOverdueBillsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOverdueBillsAtIndex:(NSUInteger)idx withObject:(BillDate *)value;
- (void)replaceOverdueBillsAtIndexes:(NSIndexSet *)indexes withOverdueBills:(NSArray *)values;
- (void)addOverdueBillsObject:(BillDate *)value;
- (void)removeOverdueBillsObject:(BillDate *)value;
- (void)addOverdueBills:(NSOrderedSet *)values;
- (void)removeOverdueBills:(NSOrderedSet *)values;
- (void)insertObject:(BillDate *)value inPaidBillsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPaidBillsAtIndex:(NSUInteger)idx;
- (void)insertPaidBills:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePaidBillsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPaidBillsAtIndex:(NSUInteger)idx withObject:(BillDate *)value;
- (void)replacePaidBillsAtIndexes:(NSIndexSet *)indexes withPaidBills:(NSArray *)values;
- (void)addPaidBillsObject:(BillDate *)value;
- (void)removePaidBillsObject:(BillDate *)value;
- (void)addPaidBills:(NSOrderedSet *)values;
- (void)removePaidBills:(NSOrderedSet *)values;

+ (id)disconnectedEntity;
- (void)addToContext:(NSManagedObjectContext *)context;
- (void)paidCurrentAndUpdateDueDate;
- (void)overdueCurrentAndUpdateDueDate;
- (BOOL)hasDueDate;
- (BOOL)hasPaidBills;
- (BOOL)hasOverdueBills;

- (NSDate *)recentPaidDate;
- (NSDate *)recentOverdueDate;

@end
