//
//  BBSettingsViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 12/8/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBSettingsViewController.h"

@interface BBSettingsViewController ()

@end

@implementation BBSettingsViewController

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
    self.upcomingSwitch.on = [SETTINGS boolForKey:@"badgeShowsUpcoming"];
    self.overdueSwitch.on = [SETTINGS boolForKey:@"badgeShowsOverdue"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upcomingValueChanged:(id)sender {
    [SETTINGS setBool:self.upcomingSwitch.on forKey:@"badgeShowsUpcoming"];
    [SETTINGS synchronize];
    [BBMethodStore scheduleAppBadgeUpdate];
}

- (IBAction)overdueValueChanged:(id)sender {
    [SETTINGS setBool:self.overdueSwitch.on forKey:@"badgeShowsOverdue"];
    [SETTINGS synchronize];
    [BBMethodStore scheduleAppBadgeUpdate];
}
@end
