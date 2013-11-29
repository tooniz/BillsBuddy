//
//  WeekDays.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRecurrenceRule;

@interface WeekDays : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * week;
@property (nonatomic, retain) BillRecurrenceRule *recurrenceRule;

- (void)addToContext:(NSManagedObjectContext *)context;

@end
