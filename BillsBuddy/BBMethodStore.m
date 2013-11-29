//
//  BBMethodStore.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBMethodStore.h"

@implementation BBMethodStore

+(BOOL)isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (int)daysBetween:(NSDate *)date1 and:(NSDate *)date2 {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayDiff = [calendar components:NSDayCalendarUnit fromDate:date1 toDate:date2 options:0];
    NSDateComponents *secondDiff = [calendar components:NSSecondCalendarUnit fromDate:date1 toDate:date2 options:0];
    
    NSInteger days;

    if ([BBMethodStore isDate:date1 sameDayAsDate:date2])
        days = 0;
    else if (dayDiff.day < 0)
        days = dayDiff.day - 1;
    else if (dayDiff.day > 0)
        days = dayDiff.day + 1;
    else if (secondDiff.second < 0)
        days = -1;
    else // notSameDay && dayDiff==0 && secondDiff>=0
        days = 1;
    return (int)days;
}

+ (NSArray *)tableViewRecords {
    return [self tableViewRecords:[VAR_STORE centerViewType]];
}

+ (NSArray *)tableViewRecords:(CenterViewType_E)viewType {
    static NSMutableArray *upcomingViewRecords;
    static NSMutableArray *paidViewRecords;
    static NSMutableArray *overdueViewRecords;
    
    if ([VAR_STORE refetchNeeded]) {
        upcomingViewRecords = nil;
        paidViewRecords = nil;
        overdueViewRecords = nil;
        upcomingViewRecords = [[NSMutableArray alloc] init];
        paidViewRecords = [[NSMutableArray alloc] init];
        overdueViewRecords = [[NSMutableArray alloc] init];
        
        NSArray* fetchedRecordsArray = [APP_DELEGATE getAllRecords];
        for (BillRecord *record in fetchedRecordsArray) {
            if (record.hasDueDate)
                [upcomingViewRecords addObject:record];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"nextDueDate" ascending:YES];
            [upcomingViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        }
        [VAR_STORE setUpcomingCount:[upcomingViewRecords count]];
        for (BillRecord *record in fetchedRecordsArray) {
            if (record.hasPaidBills)
                [paidViewRecords addObject:record];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"recentPaidDate" ascending:NO];
            [paidViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        }
        [VAR_STORE setPaidCount:[paidViewRecords count]];
        for (BillRecord *record in fetchedRecordsArray) {
            if (record.hasOverdueBills)
                [overdueViewRecords addObject:record];
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"recentOverdueDate" ascending:YES];
            [overdueViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        }
        [VAR_STORE setOverdueCount:[overdueViewRecords count]];
        [VAR_STORE setRefetchNeeded:NO];
    }
    
    switch (viewType) {
        case CV_UPCOMING:
            return upcomingViewRecords;
            break;
        case CV_PAID:
            return paidViewRecords;
            break;
        case CV_OVERDUE:
            return overdueViewRecords;
            break;
        default: {
            DAssert(0, @"called tableViewRecords with invalid viewType")
            return nil;
            break;
        }
    }
}

@end
