//
//  BBAddNotesViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 12/15/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBAddNotesViewController.h"

@interface BBAddNotesViewController ()

@end

@implementation BBAddNotesViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect notesFrame = self.notesTextView.frame;
    notesFrame.size.height -= 216;
    self.notesTextView.frame = notesFrame;
    [self.notesTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
