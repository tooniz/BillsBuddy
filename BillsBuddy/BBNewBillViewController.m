//
//  BBNewBillViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <LMAlertView.h>

#import "BBNewBillViewController.h"
#import "BillRecord.h"

#define kDescriptionTag 0
#define kCurrencyTag 1
#define kAmountTag 2

@interface BBNewBillViewController ()

@property (nonatomic, strong) NSMutableString *storedValue;
@end

@implementation BBNewBillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[VAR_STORE navBarTintColor]];
    [self.navigationController.navigationBar setTintColor:[VAR_STORE navTintColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.descriptionText setDelegate:self];
    [self.descriptionText becomeFirstResponder];
    [self.amountText setDelegate:self];
    [self.currencyButton setTitle:[VAR_STORE currencySymbol] forState:UIControlStateNormal];
    [self formatButtonToDefault:self.dueDateButton];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:@"due: today"];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[VAR_STORE buttonDarkGrayColor] range:NSMakeRange(0,4)];
    [mutableString addAttribute:NSForegroundColorAttributeName value:[VAR_STORE buttonAppTextColor] range:NSMakeRange(5,mutableString.length - 5)];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] range:NSMakeRange(5,mutableString.length - 5)];
    [self.dueDateButton setAttributedTitle:mutableString forState:UIControlStateNormal];
    [self.dueDateButton sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interaction Methods

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSave:(id)sender {
    int isValid = 1;
    NSMutableString *message = [NSMutableString stringWithString:@"Missing "];
    // check 1 - $
    if ([self.amountText.text isEqualToString:@""]) {
        [message appendString:(isValid==1) ? @"an amount" : @", an amount"];
        isValid &= 0;
    }
    // check 2 - item
    if ([self.descriptionText.text isEqualToString:@""]) {
        [message appendString:(isValid==1) ? @"a description" : @", a description"];
        isValid &= 0;
    }
    // perform action based on check results
    if (isValid) {
        BillRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"BillRecord"
                                                  inManagedObjectContext:[APP_DELEGATE managedObjectContext]];;
        record.amount = [NSDecimalNumber decimalNumberWithString:self.amountText.text];
        record.item = self.descriptionText.text;
        [APP_DELEGATE saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        LMAlertView *alert = [[LMAlertView alloc]initWithTitle: @"Uh oh!"
                                                       message: message
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (IBAction)didTapCurrencyButton:(id)sender {
}

#pragma mark - Button Methods

- (void) formatButtonToDefault:(UIButton *)button {
    [button.layer setCornerRadius:10];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:[VAR_STORE buttonBorderColor].CGColor];
    [button setClipsToBounds:YES];
    [button setTitleColor:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[VAR_STORE buttonGrayColor]];
}

- (void) formatButtonToTwoTone:(UIButton *)button firstRange:(NSRange)range1 asFirstColor:(UIColor *)color1 secondRange:(NSRange)range2 asSecondColor:(UIColor *)color2 {

}

#pragma mark - Text Field Methods

- (NSString *)formattedAmount:(NSString *)unformatted {
    if (unformatted.length > 0) {
        NSDecimalNumber *divisor = [NSDecimalNumber decimalNumberWithString:@"100"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        formatter.decimalSeparator = @".";
        NSDecimalNumber *number = [[NSDecimalNumber decimalNumberWithString:unformatted] decimalNumberByDividingBy:divisor];
        // If <1 attach "0" as formatting prefix
        NSString *prefix;
        if ([number compare:[NSNumber numberWithInt:1]] == NSOrderedAscending)
            prefix = @"0";
        else
            prefix = @"";
        NSString *formattedNumber = [NSString stringWithFormat:@"%@%@", prefix, [formatter stringFromNumber:number]];
        return formattedNumber;
    }
    return nil;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Handling amountText field
    if ([textField tag] == kAmountTag)
    {
        if (!self.storedValue)
            self.storedValue = [[NSMutableString alloc] init];

        // Handling backspace char
        if (range.length == 1) {
            [self.storedValue deleteCharactersInRange:NSMakeRange([self.storedValue length]-1, 1)];
            NSString *formatted = [self formattedAmount:self.storedValue];
            [textField setText:[NSString stringWithFormat:@"%@",formatted]];
            if (formatted) {
                DLog(@"TextField <backspace>; range = %d", (int)range.length)
                [textField setText:[NSString stringWithFormat:@"%@",formatted]];
            }
            else {
                DLog(@"TextField <clear text>; range = %d", (int)range.length)
                [textField setText:nil];
            }
        }
        // Handling default char (numbers)
        else {
            DLog(@"TextField <number char> ; range = %d", (int)range.length)
            [self.storedValue appendString:string];
            [textField setText:[NSString stringWithFormat:@"%@",[self formattedAmount:self.storedValue]]];
        }
        return NO;
    }
    
    //Returning yes allows the entered chars to be processed
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField tag] == kDescriptionTag) {
        [textField resignFirstResponder];
        [self.amountText becomeFirstResponder];
    }
    else if ([textField tag] == kAmountTag) {
        [self didTapSave:Nil];
    }
    return YES;
}
    
@end
