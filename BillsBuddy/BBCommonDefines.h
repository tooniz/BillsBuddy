//
//  BBCommonDefines.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#ifndef BillsBuddy_BBCommonDefines_h
#define BillsBuddy_BBCommonDefines_h

typedef NS_OPTIONS(NSUInteger, CenterViewType_E) {
    CV_UPCOMING,
    CV_PAID,
    CV_OVERDUE,
    CV_CATEGORIES,
    CV_SETTINGS
};

#define kOccurenceOnce 0
#define kOccurenceDaily 1
#define kOccurenceWeekly 2
#define kOccurenceMonthly 3
#define kOccurenceYearly 4
#define kOccurencePast 5

typedef enum {
    BBRecurrenceFrequencyDaily = 0,
    BBRecurrenceFrequencyWeekly = 1,
    BBRecurrenceFrequencyMonthly = 2,
    BBRecurrenceFrequencyYearly = 3
} BBRecurrenceFrequency;

//#define ALLOW_OVERDUE_IN_UPCOMING
#endif
