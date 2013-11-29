//
//  BBVariableStore.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBVariableStore.h"

@implementation BBVariableStore

EQP_SINGLETON_BEGIN(BBVariableStore)
EQP_FIELD_INT(upcomingCount, 0)
EQP_FIELD_INT(paidCount, 0)
EQP_FIELD_INT(overdueCount, 0)
EQP_FIELD_INT(numberOfRowsInLeftTable, 0)

EQP_FIELD_INT(urgentDays, 1)
EQP_FIELD_INT(upcomingDays, 7)

EQP_FIELD_INT(refetchNeeded, YES)
EQP_FIELD_ENUM(centerViewType, CV_UPCOMING)
EQP_FIELD_OBJECT(pendingBillRecord, [BillRecord disconnectedEntity])

EQP_FIELD_OBJECT(navBarTintColor, UIColorFromRGB(247, 247, 247))
EQP_FIELD_OBJECT(navTintColor, UIColorFromRGB(115, 115, 115))
EQP_FIELD_OBJECT(sidePanelColor, [UIColor darkGrayColor])
EQP_FIELD_OBJECT(sideTintColor, [UIColor colorWithWhite:0.8 alpha:1])
EQP_FIELD_OBJECT(iconTintColor, [UIColor colorWithWhite:1 alpha:1])

EQP_FIELD_OBJECT(buttonAppTextColor, UIColorFromRGB(251, 203, 67))
EQP_FIELD_OBJECT(buttonDarkGrayColor, [UIColor colorWithWhite:0.2 alpha:1])
EQP_FIELD_OBJECT(buttonGrayColor, [UIColor colorWithWhite:0.99 alpha:1])
EQP_FIELD_OBJECT(buttonBorderColor, [UIColor colorWithWhite:0.8 alpha:1])

EQP_FIELD_OBJECT(checkIconColor, UIColorFromRGB(140, 196, 116))
EQP_FIELD_OBJECT(crossIconColor, UIColorFromRGB(229, 115, 104))
EQP_FIELD_OBJECT(clockIconColor, UIColorFromRGB(251, 203, 67))
EQP_FIELD_OBJECT(listIconColor, UIColorFromRGB(171, 148, 140))

EQP_FIELD_STRING(currencySymbol, @"$")
EQP_FIELD_STRING(labelLightFontName, @"STHeitiSC-Light")
EQP_FIELD_STRING(labelDefaultFontName, @"STHeitiSC-Medium")
EQP_FIELD_STRING(buttonLightFontName, @"STHeitiSC-Medium")
EQP_FIELD_STRING(buttonDefaultFontName, @"STHeitiSC-Medium")
EQP_FIELD_STRING(panelDefaultFontName, @"Montserrat")
EQP_FIELD_STRING(navBarDefaultFontName, @"Quando")
EQP_SINGLETON_END

@end
