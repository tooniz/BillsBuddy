//
//  BillRecord.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillDate, BillRecurrenceRule;

@interface BillRecord : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) BillDate *paidBills;
@property (nonatomic, retain) BillDate *overdueBills;
@property (nonatomic, retain) BillRecurrenceRule *recurrenceRule;

@end
