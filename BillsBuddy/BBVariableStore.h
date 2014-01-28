//
//  BBVariableStore.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "EqpSingleton.h"
#import "BillRecord.h"

#define VAR_STORE (BBVariableStore *)[BBVariableStore sharedInstance]
#define SETTINGS [NSUserDefaults standardUserDefaults]

@interface BBVariableStore : EqpSingleton

// data properties
@property (nonatomic) NSInteger upcomingCount;
@property (nonatomic) NSInteger paidCount;
@property (nonatomic) NSInteger overdueCount;
@property (nonatomic) NSInteger numberOfRowsInLeftTable;
@property (nonatomic, copy) NSString *currencySymbol;

// app settings

// app properties
@property (nonatomic) BOOL refetchNeeded;
@property (nonatomic) CenterViewType_E centerViewType;
@property (nonatomic, strong) BillRecord *pendingBillRecord;

// app ui properties
@property (nonatomic, copy) NSString *labelLightFontName;
@property (nonatomic, copy) NSString *labelDefaultFontName;
@property (nonatomic, copy) NSString *buttonLightFontName;
@property (nonatomic, copy) NSString *buttonDefaultFontName;
@property (nonatomic, copy) NSString *panelDefaultFontName;
@property (nonatomic, copy) NSString *navBarDefaultFontName;
@property (nonatomic) NSInteger buttonDefaultFontSize;

@property (nonatomic, copy) UIColor *navBarTintColor;
@property (nonatomic, copy) UIColor *navTintColor;
@property (nonatomic, copy) UIColor *sidePanelColor;
@property (nonatomic, copy) UIColor *sideTintColor;
@property (nonatomic, copy) UIColor *iconTintColor;

@property (nonatomic, copy) UIColor *textGrayColor;
@property (nonatomic, copy) UIColor *buttonAppTextColor;
@property (nonatomic, copy) UIColor *buttonGrayColor;
@property (nonatomic, copy) UIColor *buttonDarkGrayColor;
@property (nonatomic, copy) UIColor *buttonBorderColor;

@property (nonatomic, copy) UIColor *checkIconColor;
@property (nonatomic, copy) UIColor *crossIconColor;
@property (nonatomic, copy) UIColor *clockIconColor;
@property (nonatomic, copy) UIColor *listIconColor;
@property (nonatomic, copy) UIColor *gearIconColor;

@end
