//
//  BBAddBillViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBAddBillViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *amountText;

@property (weak, nonatomic) IBOutlet UIButton *categoryText;

@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;
@property (weak, nonatomic) IBOutlet UIButton *notesButton;

@property (weak, nonatomic) IBOutlet UIButton *dueOneMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *dueOneWeekButton;
@property (weak, nonatomic) IBOutlet UIButton *dueTomorrowButton;
@property (weak, nonatomic) IBOutlet UIButton *dueTodayButton;
@property (weak, nonatomic) IBOutlet UIButton *dueDoneButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerWrapperView;

- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapNext:(id)sender;

- (IBAction)didTapCurrencyButton:(id)sender;
- (IBAction)didTapDueDateButton:(id)sender;
- (IBAction)didTapDueHelperButton:(id)sender;

@end
