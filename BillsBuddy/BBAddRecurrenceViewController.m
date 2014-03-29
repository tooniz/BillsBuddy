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
#import "BillRecurrenceEnd.h"

#define kRecurrenceTag 10

#define kRecurOnceText @"Once only"
#define kRecurDailyText @"Repeat daily"
#define kRecurWeeklyText @"Repeat weekly"
#define kRecurMonthlyText @"Repeat monthly"
#define kRecurYearlyText @"Repeat yearly"
#define kUndefinedText @"Undefined"

@interface BBAddRecurrenceViewController ()

@property (nonatomic, strong) BillRecurrenceRule *pendingRecurrenceRule;
@property (nonatomic, strong) BillRecurrenceEnd *pendingRecurrenceEnd;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Add line to bottm of recurrenceFieldWrapper
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0,self.view.frame.size.width, 0.5f)];
    CAShapeLayer *line_top = [CAShapeLayer layer];
    line_top.path = [linePath CGPath];
    line_top.fillColor = [[UIColor colorWithWhite:0.75 alpha:1] CGColor];
    line_top.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    CAShapeLayer *line_bot = [CAShapeLayer layer];
    line_bot.path = [linePath CGPath];
    line_bot.fillColor = [[UIColor colorWithWhite:0.75 alpha:1] CGColor];
    line_bot.frame = CGRectMake(0, self.recurrenceFieldWrapper.frame.size.height-1, self.view.frame.size.width, 1);
    [self.recurrenceFieldWrapper.layer addSublayer:line_top];
    [self.recurrenceFieldWrapper.layer addSublayer:line_bot];
    self.recurrenceField.font = [UIFont fontWithName:[VAR_STORE labelLightFontName] size:18];
    self.recurrenceField.textColor = [UIColor lightGrayColor];
    [self updateRecurrenceField:nil];
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

    if (self.recurrenceValid) {
        // Create recurrence rule in context
        BillRecord *record = (VAR_STORE).pendingBillRecord;
        [record setRecurrenceRule:self.pendingRecurrenceRule];
        // Save context
        [(VAR_STORE).pendingBillRecord addToContext:[APP_DELEGATE managedObjectContext]];
        DLog(@"Dump bill record about to be added:\n %@", record.description)
        DLog(@"Dump recurrence rule of bill record about to be added:\n %@", record.recurrenceRule.description)
        [APP_DELEGATE saveContext];
        (VAR_STORE).pendingBillRecord = nil;
        
        NSCalendarUnit repeatInterval = 0;
        if (record.recurrenceRule.recurrenceEnd == nil) {
            switch (record.recurrenceRule.frequency.intValue) {
                case BBRecurrenceFrequencyDaily:
                    repeatInterval = NSDayCalendarUnit;
                    break;
                case BBRecurrenceFrequencyWeekly:
                    repeatInterval = NSWeekCalendarUnit;
                    break;
                case BBRecurrenceFrequencyMonthly:
                    repeatInterval = NSMonthCalendarUnit;
                    break;
                case BBRecurrenceFrequencyYearly:
                    repeatInterval = NSYearCalendarUnit;
                    break;
                default:
                    break;
            }
        }
        else {
            DAssert(record.recurrenceRule.recurrenceEnd.occurenceCount.intValue == 1, @"only 1-time occurence or infinitely repeated recurrence supported for now!")
        }
        // Schedule the notification
        int hour = (int)[SETTINGS integerForKey:@"scheduledReminderHour"];
        int day = (int)[SETTINGS integerForKey:@"notificationDays"];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offset = [[NSDateComponents alloc] init];
        [offset setDay:day];
        NSDate *fireDate = [calendar dateByAddingComponents:offset toDate:record.nextDueDate options:0];
        [BBMethodStore scheduleNotificationForDate:[BBMethodStore beginningOfDay:fireDate plusHours:hour]
                                         AlertBody:StringGen(@"%@ is due", record.item)
                                 ActionButtonTitle:@"Upcoming bill"
                                    RepeatInterval:repeatInterval
                                    NotificationID:[[[record objectID] URIRepresentation] absoluteString]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        LMAlertView *alert = [[LMAlertView alloc]initWithTitle: @"Uh oh!"
                                                       message: @"Missing a recurrence type"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
        [alert show];
    }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        default:
            return 0;
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
        default:
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"cellForRowAtIndexPath called with %@", indexPath.description)
    static NSString *cellIdentifier = @"recurrenceTableCell";
    
    // Cell retrieval
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, cell.frame.size.width-40, 28)];
        itemText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:18];
        itemText.tag = kRecurrenceTag;
        NSInteger sectionRow = indexPath.section*10 + indexPath.row;
        switch (sectionRow) {
            case 00:
                itemText.text = kRecurOnceText;
                break;
            case 01:
                itemText.text = kRecurDailyText;
                break;
            case 02:
                itemText.text = kRecurWeeklyText;
                break;
/* how does notification support work?
            case 03:
                itemText.text = @"Repeat every other week";
                break;
 */
            case 03:
                itemText.text = kRecurMonthlyText;
                break;
            case 04:
                itemText.text = kRecurYearlyText;
                break;
/* how does notification support work?

            case 10:
                itemText.text = @"Repeat ... times";
                break;
            case 11:
                itemText.text = @"Repeat ... on every ...";
                break;
 */
            default:
                itemText.text = kUndefinedText;
                break;
        }
        [cell.contentView addSubview:itemText];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"tableView:didSelectRowAtIndexPath called")
    NSInteger sectionRow = indexPath.section*10 + indexPath.row;
    self.pendingRecurrenceRule = [BillRecurrenceRule disconnectedEntity];
    self.pendingRecurrenceEnd = nil;
    self.recurrenceValid = YES;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *selection = (UILabel *)[cell viewWithTag:kRecurrenceTag];
    [self updateRecurrenceField:selection.text];
    switch (sectionRow) {
        case 00:
            self.pendingRecurrenceEnd = [BillRecurrenceEnd disconnectedEntity];
            self.pendingRecurrenceEnd.occurenceCount = [NSNumber numberWithInt:1];
            [self.pendingRecurrenceRule setRecurrenceEnd:self.pendingRecurrenceEnd];
            break;
        case 01:
            self.pendingRecurrenceRule.frequency = [NSNumber numberWithInt:BBRecurrenceFrequencyDaily];
            self.pendingRecurrenceRule.interval = [NSNumber numberWithInt:1];
            break;
        case 02:
            self.pendingRecurrenceRule.frequency = [NSNumber numberWithInt:BBRecurrenceFrequencyWeekly];
            self.pendingRecurrenceRule.interval = [NSNumber numberWithInt:1];
            break;
/*
        case 03:
            self.pendingRecurrenceRule.frequency = [NSNumber numberWithInt:BBRecurrenceFrequencyWeekly];
            self.pendingRecurrenceRule.interval = [NSNumber numberWithInt:2];
            break;
 */
        case 03:
            self.pendingRecurrenceRule.frequency = [NSNumber numberWithInt:BBRecurrenceFrequencyMonthly];
            self.pendingRecurrenceRule.interval = [NSNumber numberWithInt:1];
            break;
        case 04:
            self.pendingRecurrenceRule.frequency = [NSNumber numberWithInt:BBRecurrenceFrequencyYearly];
            self.pendingRecurrenceRule.interval = [NSNumber numberWithInt:1];
            break;
/*
        case 10:
//TODO special rule
            self.recurrenceValid = NO;
            break;
        case 11:
//TODO special rule
            self.recurrenceValid = NO;
            break;
 */
        default:
            self.recurrenceValid = NO;
            break;
    }
    
}

#pragma mark - Misc Methods

- (NSMutableAttributedString *) formatStringTwoTone:(NSString *)string firstRange:(NSRange)range1 asFirstColor:(UIColor *)color1 secondRange:(NSRange)range2 asSecondColor:(UIColor *)color2 {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:string];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color1 range:range1];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:[VAR_STORE buttonDefaultFontSize]] range:range1];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    if (self.recurrenceValid)
        [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Medium" size:[VAR_STORE buttonDefaultFontSize]] range:range2];
    else
        [mutableString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiSC-Light" size:[VAR_STORE buttonDefaultFontSize]] range:range2];
    return mutableString;
}

- (void)updateRecurrenceField:(NSString *)selected {
    [self setRecurrenceValid: (selected == nil) ? NO : [selected isEqualToString:kUndefinedText] ? NO : YES];
    NSString *message = @"With frequency of: ";
    NSString *selection = self.recurrenceValid ? selected : @"Pick a rule below";
    NSString *initString = [NSString stringWithFormat:@"%@%@", message, selection];
    UIColor *secondColor = self.recurrenceValid ? [VAR_STORE buttonAppTextColor]: [UIColor lightGrayColor];
    NSMutableAttributedString *mutableString = [self formatStringTwoTone:initString firstRange:NSMakeRange(0,message.length-1) asFirstColor:[UIColor blackColor] secondRange:NSMakeRange(message.length,initString.length - message.length) asSecondColor:secondColor];
    [self.recurrenceField setAttributedText:mutableString];
}

@end
