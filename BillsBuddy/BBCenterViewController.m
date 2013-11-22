//
//  BBCenterViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBCenterViewController.h"

#import "CustomBadge.h"
#import "BBVariableStore.h"

@interface BBCenterViewController ()

@end

@implementation BBCenterViewController

CustomBadge *totalCountBadge;

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
	totalCountBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", (int)[VAR_STORE totalCount]]
                                         withStringColor:[UIColor whiteColor]
                                          withInsetColor:UIColorFromRGB(0xF05722)
                                          withBadgeFrame:NO
                                     withBadgeFrameColor:[UIColor whiteColor]
                                               withScale:1.0
                                             withShining:NO];
    [totalCountBadge setFrame:CGRectMake(22, 16, totalCountBadge.frame.size.width, totalCountBadge.frame.size.height)];
    [totalCountBadge setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar addSubview:totalCountBadge];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
