//
//  BBNewBillViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBNewBillViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *descriptionText;
@property (weak, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *dueDateButton;

- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapSave:(id)sender;

- (IBAction)didTapCurrencyButton:(id)sender;

@end
