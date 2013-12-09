//
//  BBMethodStore.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "EqpSingleton.h"

#define MET_STORE (BBMethodStore *)[BBMethodStore sharedInstance]

@interface BBMethodStore : EqpSingleton

+ (NSDate *)beginningOfDay:(NSDate *)date plusHours:(NSInteger)hours;
+ (NSDate *)endOfDay:(NSDate *)date minusHours:(NSInteger)hours;
+ (BOOL)isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2;
+ (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2;
+ (NSArray *)tableViewRecords:(CenterViewType_E)viewType;
+ (NSArray *)tableViewRecords;

@end
