//
//  BBSettingsNotifications.h
//  BillsBuddy
//
//  Created by Tony Zhou on 12/8/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSettingsNotifications : UITableViewController

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

- (IBAction)sliderValueChanged:(id)sender;

@end
