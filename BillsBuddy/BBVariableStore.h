//
//  BBVariableStore.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "EqpSingleton.h"

#define VAR_STORE (BBVariableStore *)[BBVariableStore sharedInstance]

@interface BBVariableStore : EqpSingleton

// data properties
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger numberOfRowsInCenterTable;
@property (nonatomic) NSInteger numberOfRowsInLeftTable;
@property (nonatomic, copy) NSString *currencySymbol;

// app settings
@property (nonatomic) NSInteger urgentDays;
@property (nonatomic) NSInteger upcomingDays;

// app properties
@property (nonatomic) CenterViewType_E centerViewType;
// app ui properties
@property (nonatomic, copy) NSString *labelDefaultFontName;
@property (nonatomic, copy) NSString *buttonDefaultFontName;
@property (nonatomic, copy) NSString *panelDefaultFontName;
@property (nonatomic, copy) NSString *navBarDefaultFontName;

@property (nonatomic, copy) UIColor *navBarTintColor;
@property (nonatomic, copy) UIColor *navTintColor;
@property (nonatomic, copy) UIColor *sidePanelColor;
@property (nonatomic, copy) UIColor *sideTintColor;
@property (nonatomic, copy) UIColor *iconTintColor;

@property (nonatomic, copy) UIColor *buttonAppTextColor;
@property (nonatomic, copy) UIColor *buttonGrayColor;
@property (nonatomic, copy) UIColor *buttonDarkGrayColor;
@property (nonatomic, copy) UIColor *buttonBorderColor;

@property (nonatomic, copy) UIColor *checkIconColor;
@property (nonatomic, copy) UIColor *crossIconColor;
@property (nonatomic, copy) UIColor *clockIconColor;
@property (nonatomic, copy) UIColor *listIconColor;

@end
