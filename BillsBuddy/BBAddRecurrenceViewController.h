//
//  BBAddRecurrenceViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBAddRecurrenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIView *recurrenceFieldWrapper;

- (IBAction)didTapSave:(id)sender;

@end
