//
//  BBAddNotesViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 12/15/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBAddNotesViewController.h"

@interface BBAddNotesViewController ()
// Create recurrence rule in context
@property (strong, atomic) BillRecord *record;

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
    self.notesTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"Found pendingBillRecord %@", (VAR_STORE).pendingBillRecord.description)
    self.record = (VAR_STORE).pendingBillRecord;
    self.notesTextView.text = self.record.notes;
    self.notesPlaceHolder.hidden = ([self.notesTextView.text length]>0);

    if ((VAR_STORE).addViewIsAddMode == YES)
        [self.navigationItem setTitle:@"Add notes"];
    else
        [self.navigationItem setTitle:@"Edit notes"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect notesFrame = self.notesTextView.frame;
    notesFrame.size.height -= 216;
    self.notesTextView.frame = notesFrame;
    //[self.notesTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSave:(id)sender {
    self.record.notes = self.notesTextView.text;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TextView Methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.notesPlaceHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.notesPlaceHolder.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.notesPlaceHolder.hidden = ([txtView.text length] > 0);
}

@end
