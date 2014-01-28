//
//  BBAddBillViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <LMAlertView.h>

#import "BBAddBillViewController.h"
#import "BillRecord.h"
#import "BillRecurrenceRule.h"

#define kDescriptionTag 0
#define kCurrencyTag 1
#define kAmountTag 2

#define kDueDoneTag 10
#define kDueTodayTag 11
#define kDueTomorrowTag 12
#define kDueOneWeekTag 13
#define kDueOneMonthTag 14

@interface BBAddBillViewController ()

@property (strong, nonatomic) NSMutableString *storedValue;
@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) NSString *datePickerDateString;

@end

@implementation BBAddBillViewController

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
    [self.navigationItem setBackBarButtonItem: [[UIBarButtonItem alloc] initWithTitle: @"" style: UIBarButtonItemStyleBordered target: nil action: nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Initialization
    [self setDatePickerDateString:@"today"];
    // Appearance for text fields
    [self.descriptionText setDelegate:self];
    [self.descriptionText becomeFirstResponder];
    [self.amountText setDelegate:self];
    // Appearance for buttons
    [self.currencyButton setTitle:[VAR_STORE currencySymbol] forState:UIControlStateNormal];
    [self setDueDate:self.datePicker.date];
    [self formatDueDateButton:self.datePickerDateString];
    [self formatDueHelperButtons:self.dueTodayButton];
}

- (void)viewDidAppear:(BOOL)animated {
    // Appearance for date picker/wrapper
    [self.datePicker addTarget:self action:@selector(datePickerWheelChanged) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinimumDate:[NSDate date]];
    [self.datePickerWrapperView setBackgroundColor:[VAR_STORE buttonGrayColor]];
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    [self resignDatePickerWrapperView];
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

- (IBAction)didTapNext:(id)sender {
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
        /* Remember how to create a record atomic way
        BillRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"BillRecord"
                                                  inManagedObjectContext:[APP_DELEGATE managedObjectContext]];; */
        (VAR_STORE).pendingBillRecord = [BillRecord disconnectedEntity];
        (VAR_STORE).pendingBillRecord.amount = [NSDecimalNumber decimalNumberWithString:self.amountText.text];
        (VAR_STORE).pendingBillRecord.item = self.descriptionText.text;
        (VAR_STORE).pendingBillRecord.startDate = self.dueDate;
        (VAR_STORE).pendingBillRecord.nextDueDate = self.dueDate;
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addRecurenceViewController"];
        [self.navigationController pushViewController:vc animated:YES];
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
    [self resignDatePickerWrapperView];
}

# pragma mark - Date Picker Methods

- (void) datePickerWheelChanged {
    
    NSDate *pickedDate = self.datePicker.date;

    NSDateComponents *components;
    components = [[NSDateComponents alloc] init];
    components.day = 1;
    NSDate *oneDayFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    components = [[NSDateComponents alloc] init];
    components.day = 7;
    NSDate *oneWeekFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];

    NSString *dateString;

    if ([BBMethodStore isDate:pickedDate sameDayAsDate:[NSDate date]]) {
        dateString = @"today";
        [self formatDueHelperButtons:self.dueTodayButton];
    }
    else if ([BBMethodStore isDate:pickedDate sameDayAsDate:oneDayFromNow]) {
        dateString = @"tomorrow";
        [self formatDueHelperButtons:self.dueTomorrowButton];
    }
    else if ([BBMethodStore isDate:pickedDate sameDayAsDate:oneWeekFromNow]) {
        [self formatDueHelperButtons:self.dueOneWeekButton];
    }
    else if ([BBMethodStore isDate:pickedDate sameDayAsDate:oneMonthFromNow]) {
        [self formatDueHelperButtons:self.dueOneMonthButton];
    }
    else {
        [self formatDueHelperButtons:nil];
    }

    if (!dateString)
        dateString = [NSDateFormatter localizedStringFromDate:pickedDate
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
    self.datePickerDateString = dateString;
}

- (IBAction)didTapDueDateButton:(id)sender {
    self.datePicker.hidden = NO;
    [self.descriptionText resignFirstResponder];
    [self.amountText resignFirstResponder];
    [self.dueDateButton becomeFirstResponder];

    CGRect wrapperFrame = CGRectMake(self.datePickerWrapperView.frame.origin.x,
                                     (self.view.bounds.size.height - self.datePickerWrapperView.frame.size.height),
                                     self.datePickerWrapperView.frame.size.width,
                                     self.datePickerWrapperView.frame.size.height);
    [self.datePickerWrapperView setHidden:NO];
    [UIView beginAnimations:nil context:nil];
    [self.datePickerWrapperView setFrame:wrapperFrame];
    [UIView commitAnimations];
}

- (IBAction)didTapDueHelperButton:(id)sender {

    NSDateComponents *components;

    components = [[NSDateComponents alloc] init];
    components.day = 1;
    NSDate *oneDayFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    components = [[NSDateComponents alloc] init];
    components.day = 7;
    NSDate *oneWeekFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];

    switch ([sender tag]) {
        case kDueDoneTag:
            [self resignDatePickerWrapperView];
            [self setDueDate:self.datePicker.date];
            [self formatDueDateButton:self.datePickerDateString];
            if ([self.descriptionText.text isEqualToString:@""])
                [self.descriptionText becomeFirstResponder];
            else if ([self.amountText.text isEqualToString:@""])
                [self.amountText becomeFirstResponder];
            break;
        case kDueTodayTag:
            [self.datePicker setDate:[NSDate date]];
            break;
        case kDueTomorrowTag:
            [self.datePicker setDate:oneDayFromNow];
            break;
        case kDueOneWeekTag:
            [self.datePicker setDate:oneWeekFromNow];
            break;
        case kDueOneMonthTag:
            [self.datePicker setDate:oneMonthFromNow];
            break;
        default:
            break;
    }
    [self datePickerWheelChanged];
}

#pragma mark - Button Methods

- (void) formatButtonToDefault:(UIButton *)button {
    [button.layer setCornerRadius:10];
    [button.layer setBorderWidth:0.5f];
    [button.layer setBorderColor:[VAR_STORE buttonBorderColor].CGColor];
    [button setClipsToBounds:YES];
    [button setTitleColor:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[VAR_STORE buttonGrayColor]];
}

- (void) formatDueHelperButtons:(UIButton *)selected {
    UIButton *lhs;
    UIButton *rhs = selected;
    lhs = self.dueTodayButton;
    [lhs setTitleColor:(lhs == rhs) ? [VAR_STORE buttonAppTextColor]:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    lhs = self.dueTomorrowButton;
    [lhs setTitleColor:(lhs == rhs) ? [VAR_STORE buttonAppTextColor]:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    lhs = self.dueOneWeekButton;
    [lhs setTitleColor:(lhs == rhs) ? [VAR_STORE buttonAppTextColor]:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    lhs = self.dueOneMonthButton;
    [lhs setTitleColor:(lhs == rhs) ? [VAR_STORE buttonAppTextColor]:[VAR_STORE buttonDarkGrayColor] forState:UIControlStateNormal];
    
    [self.dueDoneButton setTitleColor:[VAR_STORE buttonAppTextColor] forState:UIControlStateNormal];
}

- (void) formatDueDateButton:(NSString *)dueDate {
    NSString *message = @"due: ";
    NSString *initString = [NSString stringWithFormat:@"%@%@", message, dueDate];
    NSMutableAttributedString *mutableString = [self formatStringTwoTone:initString firstRange:NSMakeRange(0,message.length-1) asFirstColor:[VAR_STORE buttonDarkGrayColor] secondRange:NSMakeRange(message.length,initString.length - message.length) asSecondColor:[VAR_STORE buttonAppTextColor]];

    [self formatButtonToDefault:self.dueDateButton];
    [self.dueDateButton setAttributedTitle:mutableString forState:UIControlStateNormal];
    [self.dueDateButton.titleLabel setNumberOfLines:0];
    [self.dueDateButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
// FIXME these are no use, sizeToFit
//    [self.dueDateButton.titleLabel sizeToFit];
//    [self.dueDateButton.titleLabel layoutIfNeeded];
//    [self.dueDateButton sizeToFit];
//    [self.dueDateButton layoutIfNeeded];
    
    [self formatButtonToDefault:self.notesButton];
}

- (NSMutableAttributedString *) formatStringTwoTone:(NSString *)string firstRange:(NSRange)range1 asFirstColor:(UIColor *)color1 secondRange:(NSRange)range2 asSecondColor:(UIColor *)color2 {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:string];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:[VAR_STORE buttonDefaultFontSize]] range:range1];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:[VAR_STORE buttonDefaultFontSize]] range:range2];
    return mutableString;
}

- (void) resignDatePickerWrapperView {
    CGRect wrapperFrame = CGRectMake(self.datePickerWrapperView.frame.origin.x,
                                     (self.view.bounds.size.height + self.datePickerWrapperView.frame.size.height),
                                     self.datePickerWrapperView.frame.size.width,
                                     self.datePickerWrapperView.frame.size.height);
    [self.datePickerWrapperView setFrame:wrapperFrame];
    [self.datePickerWrapperView setHidden:YES];
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

// When characters entered 
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

// When done entering (resign first responder)
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField tag] == kDescriptionTag) {
        [textField resignFirstResponder];
        [self.amountText becomeFirstResponder];
    }
    else if ([textField tag] == kAmountTag) {
        [self didTapNext:nil];
    }
    return YES;
}

// When editing begins (becomes first responder)
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self resignDatePickerWrapperView];
    return YES;
}
@end
