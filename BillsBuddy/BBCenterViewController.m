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
#import "BillDate.h"

#define kCellHeight 60

@interface BBCenterViewController ()

@property (nonatomic, strong) NSArray* tableRecordsArray;
@property (nonatomic, strong) CustomBadge *totalCountBadge;
@property NSInteger totalCount;

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // FIXME LATER hack to remove extra padding caused by UITableViewStyleGrouped
    [self.tableView setContentInset:UIEdgeInsetsMake(-36, 0, 0, 0)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
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

    static NSString *cellIdentifier = @"centerTableCell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Swiped out buttons
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        if ([VAR_STORE centerViewType] == CV_UPCOMING ||
            [VAR_STORE centerViewType] == CV_OVERDUE) {
            [leftUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE checkIconColor]
                                                        icon:[UIImage imageNamed:@"check.png"]];
            [leftUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE clockIconColor]
                                                        icon:[UIImage imageNamed:@"clock.png"]];
        }
        [rightUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE sideTintColor]
                                                    title:@"More"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[VAR_STORE crossIconColor]
                                                    title:@"Delete"];
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        // Item retrieval
        BillRecord *record = [self.tableRecordsArray objectAtIndex:indexPath.row];
        // Item Image
        UIImageView *itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 40, 40)];
        itemImage.backgroundColor = [VAR_STORE sideTintColor];
//FIXME image for record
        // Item Text
        CGRect itemFrameUpper = CGRectMake(66, 11, 128, 28);
        CGRect itemFrameLower = CGRectMake(66, 15, 128, 28);
        UILabel *itemText = [[UILabel alloc] init];
        itemText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:18];
        itemText.text = record.item;
        // Item Text
        UILabel *itemDescText = [[UILabel alloc] initWithFrame:CGRectMake(66, 30, 128, 28)];
        itemDescText.textColor = [UIColor lightGrayColor];
        itemDescText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:12];
        // Item Amount Description
        UILabel *amountDescText = [[UILabel alloc] initWithFrame: CGRectMake(190, 10, 100, 23)];
        amountDescText.textColor = [UIColor lightGrayColor];
        amountDescText.textAlignment = NSTextAlignmentRight;
        amountDescText.font = [UIFont fontWithName:[VAR_STORE labelLightFontName] size:12];
        // Item Amount
        UILabel *amountText = [[UILabel alloc] initWithFrame:CGRectMake(190, 20, 100, 40)];
        switch ([VAR_STORE centerViewType]) {
            case CV_UPCOMING: {
                itemText.frame = itemFrameLower;
                NSInteger days = [BBMethodStore daysBetween:[NSDate date] and:record.date];
                NSString *daysString = abs((int)days) > 1 ? @"days" : @"day";
                amountDescText.text = (days<0) ? StringGen(@"overdue %d %@", abs(days), daysString) : (days>0) ? StringGen(@"in %d %@", (int)days, daysString) : StringGen(@"today");
                amountText.textColor = (days > [VAR_STORE urgentDays]) ? [VAR_STORE clockIconColor] : [VAR_STORE crossIconColor];
                break;
            }
            case CV_PAID: {
                itemText.frame = itemFrameUpper;
                BillDate *recent = [record.paidBills objectAtIndex:0];
                NSString *dateString = [NSDateFormatter localizedStringFromDate:recent.date
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterNoStyle];
//FIXME need to get last paid
                itemDescText.text = [NSString stringWithFormat:@"last paid %@", dateString];
                NSInteger times = record.paidBills.count;
                amountDescText.text = (times==1) ? StringGen(@"paid once") : StringGen(@"paid %d times", times);
                amountText.textColor = [VAR_STORE checkIconColor];
                break;
            }
            case CV_OVERDUE:
                amountText.textColor = [VAR_STORE crossIconColor];
                break;
            default:
                break;
        }
        amountText.textAlignment = NSTextAlignmentRight;
        amountText.font = [UIFont fontWithName:[VAR_STORE labelDefaultFontName] size:19];
        amountText.text = StringGen(@"%@%@", [VAR_STORE currencySymbol], record.amount.stringValue);
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
    
    return cell;
}

#pragma mark - SWTableViewCell Methods

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            DLog(@"Check button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            BillRecord *record = [self.tableRecordsArray objectAtIndex:cellIndexPath.row];
            [record paidCurrentAndUpdateDueDate];
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
        case 0:
            DLog(@"More button was pressed");
            break;
        case 1:
        {
            DLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            BillRecord *record = [self.tableRecordsArray objectAtIndex:cellIndexPath.row];
            [[APP_DELEGATE managedObjectContext] deleteObject:record];
            [APP_DELEGATE saveContext];
            [self updateView];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Interaction Methods

- (IBAction)didTapAdd:(id)sender {
    [self presentViewControllerWithStoryboardId:@"newBillViewController"];
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
        case CV_UPCOMING:
            [self.navigationItem setTitle:@"BillsBuddy"];
            self.totalCount = [self.tableRecordsArray count];
            break;
        case CV_PAID:
            [self.navigationItem setTitle:@"Paid bills"];
            self.totalCount = 0;
            break;
        case CV_OVERDUE:
            [self.navigationItem setTitle:@"Overdue bills"];
            self.totalCount = 0;
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

    // Debug dump
    // [VAR_STORE dump];
}

@end
