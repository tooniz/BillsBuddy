//
//  BillDate.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/28/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRecord;

@interface BillDate : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) BillRecord *overdueRecord;
@property (nonatomic, retain) BillRecord *paidRecord;

- (void)addToContext:(NSManagedObjectContext *)context;

@end
