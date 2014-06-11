//
//  CurrencyPicker.m
//
//  Version 1.2
//
//  Created by Nick Lockwood on 25/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/CurrencyPicker
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  The source code and data files in this project are the sole creation of
//  Charcoal Design and are free for use subject to the terms below. The flag
//  icons are the creation of FAMFAMFAM (http://www.famfamfam.com/lab/icons/flags/)
//  and are available for free use for any purpose with no requirement for attribution.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "CurrencyPicker.h"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface CurrencyPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end


@implementation CurrencyPicker

//doesn't use _ prefix to avoid name clash
@synthesize delegate;

+ (NSArray *)currencyNames
{
    static NSArray *_currencyNames = nil;
    if (!_currencyNames)
    {
        _currencyNames = [[[[self currencyNamesByCode] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
    }
    return _currencyNames;
}

+ (NSArray *)currencyCodes
{
    static NSArray *_currencyCodes = nil;
    if (!_currencyCodes)
    {
        _currencyCodes = [[[self currencyCodesByName] objectsForKeys:[self currencyNames] notFoundMarker:@""] copy];
    }
    return _currencyCodes;
}

+ (NSDictionary *)currencyNamesByCode
{
    static NSDictionary *_currencyNamesByCode = nil;
    if (!_currencyNamesByCode)
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"CurrencyList" ofType:@"plist"];
        NSMutableDictionary *currencyDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:sourcePath];
        NSArray *currencyArray = [[currencyDictionary allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];

        for (int i=0; i<currencyArray.count; i++)
        {
            NSString *code = [[currencyDictionary valueForKey:[currencyArray objectAtIndex:i]] objectAtIndex:1];
            namesByCode[code] = [[currencyDictionary valueForKey:[currencyArray objectAtIndex:i]] objectAtIndex:3];
        }
        _currencyNamesByCode = [namesByCode copy];
    }
    return _currencyNamesByCode;
}

+ (NSDictionary *)currencyCodesByName
{
    static NSDictionary *_currencyCodesByName = nil;
    if (!_currencyCodesByName)
    {
        NSDictionary *currencyNamesByCode = [self currencyNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in currencyNamesByCode)
        {
            codesByName[currencyNamesByCode[code]] = code;
        }
        _currencyCodesByName = [codesByName copy];
    }
    return _currencyCodesByName;
}

- (void)setup
{
    [super setDataSource:self];
    [super setDelegate:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setup];
    }
    return self;
}

- (void)setDataSource:(__unused id<UIPickerViewDataSource>)dataSource
{
    //does nothing
}

- (void)setSelectedCurrencyCode:(NSString *)currencyCode animated:(BOOL)animated
{
    NSInteger index = [[[self class] currencyCodes] indexOfObject:currencyCode];
    if (index != NSNotFound)
    {
        [self selectRow:index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCurrencyCode:(NSString *)currencyCode
{
    [self setSelectedCurrencyCode:currencyCode animated:NO];
}

- (NSString *)selectedCurrencyCode
{
    NSInteger index = [self selectedRowInComponent:0];
    return [[self class] currencyCodes][index];
}

- (void)setSelectedCurrencyName:(NSString *)currencyName animated:(BOOL)animated
{
    NSInteger index = [[[self class] currencyNames] indexOfObject:currencyName];
    if (index != NSNotFound)
    {
        [self selectRow:index inComponent:0 animated:animated];
    }
}

- (void)setSelectedCurrencyName:(NSString *)currencyName
{
    [self setSelectedCurrencyName:currencyName animated:NO];
}

- (NSString *)selectedCurrencyName
{
    NSInteger index = [self selectedRowInComponent:0];
    return [[self class] currencyNames][index];
}

- (void)setSelectedLocale:(NSLocale *)locale animated:(BOOL)animated
{
    [self setSelectedCurrencyCode:[locale objectForKey:NSLocaleCurrencyCode] animated:animated];
}

- (void)setSelectedLocale:(NSLocale *)locale
{
    [self setSelectedLocale:locale animated:NO];
}

- (NSLocale *)selectedLocale
{
    NSString *currencyCode = self.selectedCurrencyCode;
    if (currencyCode)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCurrencyCode: currencyCode}];
        return [NSLocale localeWithLocaleIdentifier:identifier];
    }
    return nil;
}

#pragma mark -
#pragma mark UIPicker

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView numberOfRowsInComponent:(__unused NSInteger)component
{
    return [[[self class] currencyCodes] count];
}

- (UIView *)pickerView:(__unused UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(__unused NSInteger)component reusingView:(UIView *)view
{
    NSUInteger width = [[UIScreen mainScreen] bounds].size.width;
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, width, 34)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        //        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
        //        flagView.contentMode = UIViewContentModeScaleAspectFit;
        //        flagView.tag = 2;
        //        [view addSubview:flagView];
    }
    
    ((UILabel *)[view viewWithTag:1]).text = [[self class] currencyNames][row];
    return view;
}

- (void)pickerView:(__unused UIPickerView *)pickerView
      didSelectRow:(__unused NSInteger)row
       inComponent:(__unused NSInteger)component
{
    [delegate currencyPicker:self didSelectCurrencyWithName:self.selectedCurrencyName code:self.selectedCurrencyCode];
}

@end
