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
    self.prefs = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
