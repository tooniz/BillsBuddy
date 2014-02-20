//
//  BBCenterViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBCenterViewController.h"

#import "CustomBadge.h"
#import "BillRecord.h"
#import "BillRecurrenceRule.h"
#import "BillRecurrenceEnd.h"
#import "BillDate.h"

#define kCellHeight 60

#define kCellItemImageTag 100
#define kCellItemTextTag 101
#define kCellItemDescTag 102
#define kCellAmountDescTag 103
#define kCellAmountTag 104

@interface BBCenterViewController ()

@property (nonatomic, strong) NSArray* tableRecordsArray;
@property (nonatomic, strong) CustomBadge *totalCountBadge;
@property NSInteger totalCount;
@property BOOL billsCleared;
@property (nonatomic, strong) NSMutableArray *scrollableCells;

@end

@implementation BBCenterViewController

#pragma mark - Default Overrides

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
    // Setting up leftBarButtonItem (first part done in BBSidePanelController)
    self.totalCountBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", 0]
                                              withStringColor:[UIColor whiteColor]
                                               withInsetColor:[VAR_STORE crossIconColor]
                                               withBadgeFrame:NO
                                          withBadgeFrameColor:[UIColor whiteColor]
                                                    withScale:1.0
                                                  withShining:NO];
    [self.totalCountBadge setFrame:CGRectMake(25, 16, self.totalCountBadge.frame.size.width, self.totalCountBadge.frame.size.height)];
    [self.totalCountBadge setUserInteractionEnabled:NO];

    // Setting up navigationBar
    [self.navigationController.navigationBar setBarTintColor:[VAR_STORE navBarTintColor]];
    [self.navigationController.navigationBar setTintColor:[VAR_STORE navTintColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // Others
    self.scrollableCells = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setContentInset:UIEdgeInsetsMake(self.infoView.frame.size.height, 0, 0, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(self.infoView.frame.size.height,0,0,0)];
    DLog(@"viewWillAppear called")
    [self.navigationController.navigationBar addSubview:self.totalCountBadge];
    [self updateView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    DLog(@"viewDidDisappear called")
    [self.totalCountBadge removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableRecordsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //DLog(@"cellForRowAtIndexPath called")
    static NSString *cellIdentifier = @"centerTableCell";
    
    // Item retrieval
    BillRecord *record = [self.tableRecordsArray objectAtIndex:indexPath.row];
    //DLog(@"record to be displayed in cell:\n %@ \n with recurrenceRule:\n %@ with recurrenceEnd:\n %@", record.description, record.recurrenceRule.description, record.recurrenceRule.recurrenceEnd.description)
    
    // Cell retrieval
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        DLog(@"nil cell returned")
        // Swiped out buttons
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        if ([VAR_STORE centerViewType] == CV_UPCOMING ||
            [VAR_STORE centerViewType] == CV_OVERDUE) {
            [leftUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE checkIconColor]
                                                        icon:[UIImage imageNamed:@"check.png"]];
            [leftUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE clockIconColor]
                                                        icon:[UIImage imageNamed:@"clock.png"]];
            [rightUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE crossIconColor]
                                                        title:@"Delete"];
        }
//        [rightUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE sideTintColor]
 //                                                   title:@"More"];
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        // Item Image
        UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 40, 40)];
        itemImage.tag = kCellItemImageTag;
        itemImage.backgroundColor = [VAR_STORE sideTintColor];
        // Item Text
        UILabel *itemText = [[UILabel alloc] init];
        itemText.tag = kCellItemTextTag;
        itemText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:16];
        // Item Desc Text
        UILabel *itemDescText = [[UILabel alloc] initWithFrame:CGRectMake(67, 27, 138, 28)];
        itemDescText.tag = kCellItemDescTag;
        itemDescText.textColor = [VAR_STORE textGrayColor];
        itemDescText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:12];
        // Item Amount Description
        UILabel *amountDescText = [[UILabel alloc] initWithFrame: CGRectMake(200, 8, 100, 23)];
        amountDescText.tag = kCellAmountDescTag;
        amountDescText.textColor = [VAR_STORE textGrayColor];
        amountDescText.textAlignment = NSTextAlignmentRight;
        amountDescText.font = [UIFont fontWithName:[VAR_STORE labelLightFontName] size:12];
        // Item Amount
        UILabel *amountText = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 100, 40)];
        amountText.tag = kCellAmountTag;
        amountText.textAlignment = NSTextAlignmentRight;
        amountText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:20];
        // Cell subviews
        [cell.contentView addSubview:itemImage];
        [cell.contentView addSubview:itemText];
        [cell.contentView addSubview:itemDescText];
        [cell.contentView addSubview:amountDescText];
        [cell.contentView addSubview:amountText];
        // Cell management
        [cell setCellHeight:kCellHeight];
        cell.delegate = self;
    }
    
    // Updates needs to be outside nil block so it occurs with every reloadData call
    UIImageView *itemImage = (UIImageView *)[cell viewWithTag:kCellItemImageTag];
    UILabel *itemDescText = (UILabel *)[cell viewWithTag:kCellItemDescTag];
    UILabel *itemText = (UILabel *)[cell viewWithTag:kCellItemTextTag];
    UILabel *amountDescText = (UILabel *)[cell viewWithTag:kCellAmountDescTag];
    UILabel *amountText = (UILabel *)[cell viewWithTag:kCellAmountTag];
    CGRect itemFrameUpper = CGRectMake(66, 10, 138, 28);
    CGRect itemFrameLower = CGRectMake(66, 15, 138, 28);

//FIXME need to update image for record
    itemImage = itemImage;
    itemText.text = record.item;
    amountText.text = StringGen(@"%@%@", [VAR_STORE currencySymbol], record.amount.stringValue);
    switch ([VAR_STORE centerViewType]) {
        case CV_UPCOMING: {
            itemText.frame = itemFrameLower;
            NSInteger days;
#ifdef ALLOW_OVERDUE_IN_UPCOMING
            if (record.overdueBills.count == 0) {
                DAssert(record.nextDueDate, @"cannot have nil nextDueDate \n%@", record.description)
                days = [BBMethodStore daysBetween:[NSDate date] and:record.nextDueDate];
            }
            else {
                days = [BBMethodStore daysBetween:[NSDate date] and:[record recentOverdueDate]];
            }
#else
            DAssert(record.nextDueDate, @"cannot have nil nextDueDate \n%@", record.description)
            days = [BBMethodStore daysBetween:[NSDate date] and:record.nextDueDate];
#endif
            NSInteger urgentDays = [SETTINGS integerForKey:@"urgentDays"];
            NSString *daysString = abs((int)days) > 1 ? @"days" : @"day";
            amountDescText.text = (days<0) ? StringGen(@"overdue %d %@", abs(days), daysString) : (days>0) ? StringGen(@"in %d %@", (int)days, daysString) : StringGen(@"today");
            amountText.textColor = (days > urgentDays) ? [VAR_STORE clockIconColor] : [VAR_STORE crossIconColor];
            break;
        }
        case CV_PAID: {
            itemText.frame = itemFrameUpper;
            NSString *dateString = [NSDateFormatter localizedStringFromDate:[record recentPaidDate]
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterNoStyle];
            itemDescText.text = [NSString stringWithFormat:@"last paid %@", dateString];
            NSInteger times = record.paidBills.count;
            amountDescText.text = (times==1) ? StringGen(@"paid once") : StringGen(@"paid %d times", (int)times);
            amountText.textColor = [VAR_STORE checkIconColor];
            break;
        }
        case CV_OVERDUE: {
            itemText.frame = itemFrameUpper;
            NSString *dateString = [NSDateFormatter localizedStringFromDate:[record recentOverdueDate]
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterNoStyle];
            itemDescText.text = [NSString stringWithFormat:@"last missed on %@", dateString];
            NSInteger times = record.overdueBills.count;
            amountDescText.text = (times==1) ? StringGen(@"%d bill overdue", (int)times) : StringGen(@"%d bills overdue", (int)times);
            amountText.textColor = [VAR_STORE crossIconColor];
            break;
        }
        default:
            break;
    }

    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    DLog(@"scrollViewWillBeginDragging called")
    UITableView *tableView = (UITableView *)scrollView;
    NSArray *cells = [tableView visibleCells];
    [self.scrollableCells removeAllObjects];
    for (SWTableViewCell *cell in cells) {
        [cell setScrollEnabled:NO];
        [self.scrollableCells addObject:cell];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    DLog(@"scrollViewDidEndDragging called")
    for (SWTableViewCell *cell in self.scrollableCells)
        [cell setScrollEnabled:YES];
    [self.scrollableCells removeAllObjects];
}

#pragma mark - SWTableViewCell Methods

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            DLog(@"Check button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            BillRecord *record = [self.tableRecordsArray objectAtIndex:cellIndexPath.row];
            [record paidCurrentAndUpdateDueDate];
            if (record.hasDueDate) {
                for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                    NSString *notificationId = [notification.userInfo objectForKey:@"id"];
                    if ([notificationId isEqualToString:[[[record objectID] URIRepresentation] absoluteString]]) {
                        [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        DLog(@"just cancelled notification: \n%@", notification.description);
                        int hour = (int)[SETTINGS integerForKey:@"scheduledReminderHour"];
                        int day = (int)[SETTINGS integerForKey:@"notificationDays"];
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDateComponents *offset = [[NSDateComponents alloc] init];
                        [offset setDay:day];
                        NSDate *fireDate = [calendar dateByAddingComponents:offset toDate:record.nextDueDate options:0];
                        [BBMethodStore scheduleNotificationForDate:[BBMethodStore beginningOfDay:fireDate plusHours:hour]
                                                         AlertBody:notification.alertBody
                                                 ActionButtonTitle:notification.alertAction
                                                    RepeatInterval:notification.repeatInterval
                                                    NotificationID:notificationId];
                        DLog(@"just set notification: \n%@", notification.description);
                        break;
                    }
                }
            }
            else {
                [BBMethodStore cancelLocalNotification:[[[record objectID] URIRepresentation] absoluteString]]; // delete notification with id
            }
#ifdef ALLOW_OVERDUE_IN_UPCOMING
            // need to decide to udpate nextDueDate or get rid of an overdueDate
#endif
            [self updateView];
            break;
        }
        case 1:
            DLog(@"Clock button was pressed");
            break;
        default:
            break;
    }
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
/* TODO see above "more" button
        case 0:
            DLog(@"More button was pressed");
            break;
*/
        case 0:
        {
            DLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            BillRecord *record = [self.tableRecordsArray objectAtIndex:cellIndexPath.row];
            [[APP_DELEGATE managedObjectContext] deleteObject:record];
            [APP_DELEGATE saveContext];
            [BBMethodStore cancelLocalNotification:[[[record objectID] URIRepresentation] absoluteString]]; // delete notification with id
            [self updateView];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Interaction Methods

- (IBAction)didTapAdd:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addBillNavController"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Misc Methods

- (void)presentViewControllerWithStoryboardId:(NSString *)storyboardId {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)updateView {

    [self setTableRecordsArray:[BBMethodStore tableViewRecords]];
    NSInteger oldCount = self.totalCount;

    // Update table view
    switch ([VAR_STORE centerViewType]) {
        case CV_UPCOMING: {
            [self.navigationItem setTitle:@"BillsBuddy"];
            self.totalCount = [VAR_STORE upcomingCount];
            break;
        }
        case CV_PAID:
            [self.navigationItem setTitle:@"Paid bills"];
            self.totalCount = 0;
            break;
        case CV_OVERDUE:
            [self.navigationItem setTitle:@"Overdue bills"];
            self.totalCount = [VAR_STORE overdueCount];
            break;
        default:
            break;
    }
    [self.tableView reloadData];

    // Update badge view
    DLog(@"[DEBUG] oldCount = %d, totalCount = %d", (int)oldCount, (int)self.totalCount)
    [self.totalCountBadge setHidden:(self.totalCount==0)];
    if (oldCount != self.totalCount && self.totalCount != 0) {
        DLog(@"[DEBUG] totalCountBadge update")
        NSString *numString = [NSString stringWithFormat:@""];
        [self.totalCountBadge autoBadgeSizeWithString:numString];
        [self.totalCountBadge setFrame:CGRectMake(self.totalCountBadge.frame.origin.x,
                                                  self.totalCountBadge.frame.origin.y,
                                                  self.totalCountBadge.frame.size.width/2,
                                                  self.totalCountBadge.frame.size.height/2)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelay:0.1];
        numString = [NSString stringWithFormat:@"%d", (int)self.totalCount];
        [self.totalCountBadge autoBadgeSizeWithString:numString];
        [UIView commitAnimations];
    }

    // Update cleared status
    self.billsCleared = (self.tableRecordsArray.count == 0);
    if (self.billsCleared) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelay:0.1];
        self.billsClearedImage.frame = CGRectMake(0,
                                                  0,
                                                  self.billsClearedImage.frame.size.width,
                                                  self.billsClearedImage.frame.size.height);
        [UIView commitAnimations];
        self.tableView.alpha = 0;
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelay:0.1];
        self.billsClearedImage.frame = CGRectMake(0,
                                                  self.billsClearedImage.frame.size.height,
                                                  self.billsClearedImage.frame.size.width,
                                                  self.billsClearedImage.frame.size.height);
        [UIView commitAnimations];
        self.tableView.alpha = 1;
    }
    
    // Update info views
    self.numBillsLabel.text = StringGen(@"%d", (int)[self.tableRecordsArray count]);
    self.numBillsLabel.textColor = (self.billsCleared || [VAR_STORE centerViewType] == CV_PAID) ? [VAR_STORE checkIconColor] : [VAR_STORE crossIconColor];
    
    NSDecimalNumber *sum = [[NSDecimalNumber alloc] initWithInt:0];
    for (BillRecord *record in self.tableRecordsArray) {
        NSDecimalNumber *multiplier = [[NSDecimalNumber alloc] initWithInteger:
        [VAR_STORE centerViewType] == CV_UPCOMING ? 1 :
        [VAR_STORE centerViewType] == CV_PAID ? record.paidBills.count :
        [VAR_STORE centerViewType] == CV_OVERDUE ? record.overdueBills.count : 0 ];
        NSDecimalNumber *product = [[NSDecimalNumber alloc] initWithDecimal:[record.amount decimalNumberByMultiplyingBy:multiplier].decimalValue];
        sum = [sum decimalNumberByAdding:product];
    }
    self.totalAmtLabel.text = StringGen(@"%@%@", [VAR_STORE currencySymbol], sum.stringValue);
    self.totalAmtLabel.textColor = (self.billsCleared || [VAR_STORE centerViewType] == CV_PAID) ? [VAR_STORE checkIconColor] : [VAR_STORE crossIconColor];

    // Debug dump
    // [VAR_STORE dump];
}

@end
