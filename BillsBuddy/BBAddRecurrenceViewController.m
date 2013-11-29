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

@property (nonatomic) BBRecurrenceFrequency recurrenceFreq;
@property (nonatomic) BOOL recurrenceValid;

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
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self setRecurrenceValid:NO];
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
    self.recurrenceField.font = [UIFont fontWithName:[VAR_STORE labelLightFontName] size:18];
    self.recurrenceField.textColor = [UIColor lightGrayColor];
    
    NSString *message = @"With frequency of: ";
    NSString *initString = [NSString stringWithFormat:@"%@%@", message, @"Pick a rule below"];
    NSMutableAttributedString *mutableString = [self formatStringTwoTone:initString firstRange:NSMakeRange(0,message.length-1) asFirstColor:[UIColor blackColor] secondRange:NSMakeRange(message.length,initString.length - message.length) asSecondColor:[UIColor lightGrayColor]];
    
    [self.recurrenceField setAttributedText:mutableString];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
//FIXME dummy frequency of daily for now
    [recurrence setFrequency:[NSNumber numberWithInt:BBRecurrenceFrequencyDaily]];
    // Create record in context
    BillRecord *record = (VAR_STORE).pendingBillRecord;
    [record setRecurrenceRule:recurrence];
    // Save context
    DLog(@"Dump bill record about to be added:\n %@", record.description)
    DLog(@"Dump recurrence rule of bill record about to be added:\n %@", record.recurrenceRule.description)
    [APP_DELEGATE saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableAttributedString *) formatStringTwoTone:(NSString *)string firstRange:(NSRange)range1 asFirstColor:(UIColor *)color1 secondRange:(NSRange)range2 asSecondColor:(UIColor *)color2 {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:string];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:14] range:range1];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:14] range:range2];
    return mutableString;
}

#pragma mark - Table View Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 30 + self.recurrenceFieldWrapper.frame.size.height;
            break;
        default:
            return 20;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
            break;
        default:
            return 2;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Rules";
            break;
        case 1:
            sectionName = @"Special rules";
            break;
        default:
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"cellForRowAtIndexPath called")
    static NSString *cellIdentifier = @"recurrenceTableCell";
    
    // Cell retrieval
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, cell.frame.size.width-40, 28)];
        itemText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:18];
        NSInteger sectionRow = indexPath.section*10 + indexPath.row;
        switch (sectionRow) {
            case 00:
                itemText.text = @"Once only";
                break;
            case 01:
                itemText.text = @"Repeat daily";
                break;
            case 02:
                itemText.text = @"Repeat weekly";
                break;
            case 03:
                itemText.text = @"Repeat every other week";
                break;
            case 04:
                itemText.text = @"Repeat monthly";
                break;
            case 05:
                itemText.text = @"Repeat yearly";
                break;
            case 10:
                itemText.text = @"Repeat ... times";
                break;
            case 11:
                itemText.text = @"Repeat ... on every ...";
                break;
            default:
                itemText.text = @"Undefined";
                break;
        }
        [cell.contentView addSubview:itemText];
    }
    return cell;
}

@end
