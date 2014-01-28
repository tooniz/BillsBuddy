//
//  BBMethodStore.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBMethodStore.h"

@implementation BBMethodStore

+ (NSDate *)beginningOfDay:(NSDate *)date plusHours:(NSInteger)hours
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    [components setHour:0 + hours];
    [components setMinute:0];
    [components setSecond:0];
    return [cal dateFromComponents:components];
}

+ (NSDate *)endOfDay:(NSDate *)date minusHours:(NSInteger)hours
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    [components setHour:23 - hours];
    [components setMinute:59];
    [components setSecond:59];
    return [cal dateFromComponents:components];
}

+ (BOOL)isDate:(NSDate*)date1 sameDayAsDate:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2 {
    NSDate *beginningOfDate1 = [BBMethodStore beginningOfDay:date1 plusHours:0];
    NSDate *endOfDate1 = [BBMethodStore endOfDay:date1 minusHours:0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *beginningDayDiff = [calendar components:NSDayCalendarUnit fromDate:beginningOfDate1 toDate:date2 options:0];
    NSDateComponents *endDayDiff = [calendar components:NSDayCalendarUnit fromDate:endOfDate1 toDate:date2 options:0];
    if (beginningDayDiff.day > 0)
        return beginningDayDiff.day;
    else if (endDayDiff.day < 0)
        return endDayDiff.day;
    else {
        DAssert(beginningDayDiff.day == endDayDiff.day && beginningDayDiff.day == 0, @"two calculations should match and equal to 0")
        return 0;
    }
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
        [VAR_STORE setUpcomingCount:0];
        [VAR_STORE setPaidCount:0];
        [VAR_STORE setOverdueCount:0];
        
        NSArray* fetchedRecordsArray = [APP_DELEGATE getAllRecords];
        NSSortDescriptor *descriptor;
        
        for (BillRecord *record in fetchedRecordsArray) {
            // BACKGROUND UPDATES
            if (record.hasDueDate && [BBMethodStore daysBetween:[NSDate date] and:record.nextDueDate] < 0)
                [record overdueCurrentAndUpdateDueDate];
                
            // UPCOMING SECTION
            if (record.hasDueDate) {
                NSInteger upcomingDays = [SETTINGS integerForKey:@"upcomingDays"];
                if ([BBMethodStore daysBetween:[NSDate date] and:record.nextDueDate] <= upcomingDays) {
                    [upcomingViewRecords addObject:record];
                    (VAR_STORE).upcomingCount += 1;
                }
            }
#ifdef ALLOW_OVERDUE_IN_UPCOMING
            if (record.hasOverdueBills)
                [upcomingViewRecords addObject:record];
            if (record.hasOverdueBills)
                (VAR_STORE).upcomingCount += record.overdueBills.count;
#endif
            // PAID SECTION
            if (record.hasPaidBills) {
                [paidViewRecords addObject:record];
                (VAR_STORE).paidCount += record.paidBills.count;
            }
            // OVERDUE SECTION
            if (record.hasOverdueBills) {
                [overdueViewRecords addObject:record];
                (VAR_STORE).overdueCount+= record.overdueBills.count;
            }
        }
        descriptor = [[NSSortDescriptor alloc] initWithKey:@"nextDueDate" ascending:YES];
        [upcomingViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];

        descriptor = [[NSSortDescriptor alloc] initWithKey:@"recentPaidDate" ascending:NO];
        [paidViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];

        descriptor = [[NSSortDescriptor alloc] initWithKey:@"recentOverdueDate" ascending:YES];
        [overdueViewRecords sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];

        [VAR_STORE setRefetchNeeded:NO];
    }
    
    [self scheduleAppBadgeUpdate];

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

+ (void) scheduleAppBadgeUpdate {
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.alertBody = nil;
    notification.soundName = nil;
    notification.applicationIconBadgeNumber = 0;
    if ([SETTINGS boolForKey:@"badgeShowsUpcoming"] == YES)
        notification.applicationIconBadgeNumber += (VAR_STORE).upcomingCount;
    if ([SETTINGS boolForKey:@"badgeShowsOverdue"] == YES)
        notification.applicationIconBadgeNumber += (VAR_STORE).overdueCount;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void) scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle RepeatInterval:(NSCalendarUnit)repeatInterval NotificationID:(NSString *)notificationID{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    localNotification.repeatInterval = repeatInterval;
    // TODO
    //        localNotification.alertLaunchImage = ...;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:@"id"];
    DLog(@"userInfo dict:\n %@", infoDict.description)
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    DLog(@"just set notification: \n%@", localNotification.description);
}

+ (void) cancelLocalNotification:(NSString*)notificationID {
    //loop through all scheduled notifications and cancel the one we're looking for
    UILocalNotification *cancelThisNotification = nil;
    BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        DAssert(someNotification.userInfo != nil, @"userInfo cannot be null")
        if([[someNotification.userInfo objectForKey:@"id"] isEqualToString:notificationID]) {
            cancelThisNotification = someNotification;
            hasNotification = YES;
            break;
        }
    }
    if (hasNotification == YES) {
        NSLog(@"%@ ",cancelThisNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
        DLog(@"just cancelled notification: \n%@", cancelThisNotification.description);
    }
}

@end
