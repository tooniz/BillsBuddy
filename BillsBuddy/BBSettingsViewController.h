    //
//  BBSettingsViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 12/8/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *upcomingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *overdueSwitch;

- (IBAction)upcomingValueChanged:(id)sender;
- (IBAction)overdueValueChanged:(id)sender;
@end
