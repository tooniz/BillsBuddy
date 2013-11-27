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
#import "BBCenterTableCell.h"

@interface BBCenterViewController ()

@property (nonatomic,strong) NSArray* fetchedRecordsArray;
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
    self.totalCountBadge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", (int)[VAR_STORE totalCount]]
                                              withStringColor:[UIColor whiteColor]
                                               withInsetColor:[VAR_STORE crossIconColor]
                                               withBadgeFrame:NO
                                          withBadgeFrameColor:[UIColor whiteColor]
                                                    withScale:1.0
                                                  withShining:NO];
    [self.totalCountBadge setFrame:CGRectMake(25, 16, self.totalCountBadge.frame.size.width, self.totalCountBadge.frame.size.height)];
    [self.totalCountBadge setUserInteractionEnabled:NO];

    // Setting up navigationBar
    [self.navigationController.navigationBar addSubview:self.totalCountBadge];
    [self.navigationController.navigationBar setBarTintColor:[VAR_STORE navBarTintColor]];
    [self.navigationController.navigationBar setTintColor:[VAR_STORE navTintColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear called")
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BillRecord *record = [self.fetchedRecordsArray objectAtIndex:row];
        [[APP_DELEGATE managedObjectContext] deleteObject:record];
        [APP_DELEGATE saveContext];
        [self updateView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BBCenterTableCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [VAR_STORE numberOfRowsInCenterTable];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"centerTableCell";
    UINib *nib = [UINib nibWithNibName:@"BBCenterTableCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellId];
    
    BBCenterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              cellId];
    if (cell == nil) {
        cell = [[BBCenterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSUInteger row = [indexPath row];

    BillRecord * record = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
//FIXME hack days to be different
    NSUInteger days = row;
    cell.itemText.text = record.item;
    cell.amountText.text = StringGen(@"%@%@", [VAR_STORE currencySymbol], record.amount.stringValue);
    cell.deadlineText.text = StringGen(@"in %d days", (int)days);

    switch ([VAR_STORE centerViewType]) {
        case CV_UPCOMING:
            cell.amountText.textColor = (days > [VAR_STORE urgentDays]) ? [VAR_STORE clockIconColor] : [VAR_STORE crossIconColor];
            break;
        case CV_PAID:
            cell.amountText.textColor = [VAR_STORE checkIconColor];
            break;
        case CV_OVERDUE:
            cell.amountText.textColor = [VAR_STORE crossIconColor];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Misc Methods

- (IBAction)didTapAdd:(id)sender {
    [self presentViewControllerWithStoryboardId:@"newBillViewController"];
}

- (void)presentViewControllerWithStoryboardId:(NSString *)storyboardId {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


- (void)updateView {

    self.fetchedRecordsArray = [APP_DELEGATE getAllRecords];

    // Update table view
    switch ([VAR_STORE centerViewType]) {
        case CV_UPCOMING:
            [self.navigationItem setTitle:@"BillsBuddy"];
            [VAR_STORE setTotalCount:[self.fetchedRecordsArray count]];
            [VAR_STORE setNumberOfRowsInCenterTable:[self.fetchedRecordsArray count]];
            break;
        case CV_PAID:
//FIXME
            [self.navigationItem setTitle:@"Paid bills"];
            [VAR_STORE setTotalCount:0];
            [VAR_STORE setNumberOfRowsInCenterTable:1];
            break;
        case CV_OVERDUE:
//FIXME
            [self.navigationItem setTitle:@"Overdue bills"];
            [VAR_STORE setTotalCount:0];
            [VAR_STORE setNumberOfRowsInCenterTable:2];
            break;
        default:
            break;
    }
    [self.tableView reloadData];

    // Update badge view
    NSInteger oldCount = self.totalCount;
    self.totalCount = [VAR_STORE totalCount];
    
    if (oldCount != self.totalCount && self.totalCount != 0) {
        NSString *numString = [NSString stringWithFormat:@""];
        [self.totalCountBadge setAlpha:1];
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
    else {
        [self.totalCountBadge setHidden:[VAR_STORE totalCount]==0];
    }

    // Debug dump
    [VAR_STORE dump];
}

@end
