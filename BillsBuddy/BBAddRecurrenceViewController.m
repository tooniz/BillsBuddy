//
//  BBAddRecurrenceViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/27/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBAddRecurrenceViewController.h"
#import "BillRecord.h"
#import "BillRecurrenceRule.h"

@interface BBAddRecurrenceViewController ()

@end

@implementation BBAddRecurrenceViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Add line to bottm of recurrenceFieldWrapper
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width, 0.5f)];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = [linePath CGPath];
    line.fillColor = [[UIColor colorWithWhite:0.75 alpha:1] CGColor];
    line.frame = CGRectMake(0, self.recurrenceFieldWrapper.frame.size.height-1, self.view.frame.size.width, 1);
    [self.recurrenceFieldWrapper.layer addSublayer:line];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSave:(id)sender {
    [(VAR_STORE).pendingBillRecord addToContext:[APP_DELEGATE managedObjectContext]];
    // Create recurrence rule in context
    BillRecurrenceRule *recurrence = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"BillRecurrenceRule"
                                      inManagedObjectContext:[APP_DELEGATE managedObjectContext]];
//FIXME dummy frequency of once for now
    [recurrence setFrequency:[NSNumber numberWithInt:1]];
    // Create record in context
    BillRecord *record = (VAR_STORE).pendingBillRecord;
    [record setRecurrenceRule:recurrence];
    // Save context
    DLog(@"Dump bill record about to be added:\n %@", record.description)
    DLog(@"Dump recurrence rule of bill record about to be added:\n %@", record.recurrenceRule.description)
    [APP_DELEGATE saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
