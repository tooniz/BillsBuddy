//
//  BBAddRecurrenceViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <LMAlertView.h>

@interface BBAddRecurrenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *recurrenceFieldWrapper;
@property (weak, nonatomic) IBOutlet UILabel *recurrenceField;

- (IBAction)didTapSave:(id)sender;

@end
