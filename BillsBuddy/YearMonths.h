//
//  YearMonths.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/26/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillRecurrenceRule;

@interface YearMonths : NSManagedObject

@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) BillRecurrenceRule *recurrenceRule;

- (void)addToContext:(NSManagedObjectContext *)context;

@end
