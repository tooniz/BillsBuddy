//
//  BBLeftViewController.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/21/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBLeftViewController.h"
#import "BBLeftTableCell.h"

@interface BBLeftViewController ()

@end

@implementation BBLeftViewController

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
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [BBLeftTableCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BBLeftTableCell getCellHeight];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    else if (section == 1)
        return 1; // FIXME if CATEGORIES implemented, change this to 2
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DLog(@"viewForHeaderInSection called")
    CGFloat offset = 14.0;
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    [view setBackgroundColor:[VAR_STORE sidePanelColor]]; //your background color...
    // Create custom view to display section header...
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0, tableView.frame.size.width, height)];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[VAR_STORE sideTintColor]];
    // Section header text ...
    NSString *string;
    if (section == 0)
        string = @"BILLS";
    else if (section == 1)
        string = @"OTHERS";
    else
        string = @"UNSET";
    [label setText:string];
    [view addSubview:label];
    // Section header underline ...
    UIImageView *bar = [[UIImageView alloc] initWithFrame:CGRectMake(offset, height-10, tableView.frame.size.width-70, 2)];
    [bar setBackgroundColor:[VAR_STORE sideTintColor]];
    [view addSubview:bar];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"leftTableCell";
    UINib *nib = [UINib nibWithNibName:@"BBLeftTableCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellId];
    
    // Create cell for each left table item
    BBLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               cellId];
    if (cell == nil) {
        cell = [[BBLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setBackgroundColor:[VAR_STORE sidePanelColor]];
    
    // Create selected view for each cell
    UIView *bg = [[UIView alloc] init];
    bg.layer.cornerRadius = 7;
    bg.layer.masksToBounds = YES;

    // Create contents for each cell
    UIImage *iconImage;
    NSInteger sectionRow = indexPath.section*10 + indexPath.row;
    int count;
    switch (sectionRow) {
        case 00:
            iconImage = [[UIImage imageNamed:@"clock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [bg setBackgroundColor:[VAR_STORE clockIconColor]];
            [cell.icon setBackgroundColor:[VAR_STORE clockIconColor]];
            [cell.itemLabel setText:@"Upcoming bills"];
            count = (int)[VAR_STORE upcomingCount];
            [cell.countLabel setText:(count > 0) ? [NSString stringWithFormat:@"%d", count] : @"" ];
            break;
        case 01:
            iconImage = [[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [bg setBackgroundColor:[VAR_STORE checkIconColor]];
            [cell.icon setBackgroundColor:[VAR_STORE checkIconColor]];
            [cell.itemLabel setText:@"Paid bills"];
            count = (int)[VAR_STORE paidCount];
            [cell.countLabel setText:@""];
            break;
        case 02:
            iconImage = [[UIImage imageNamed:@"cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [bg setBackgroundColor:[VAR_STORE crossIconColor]];
            [cell.icon setBackgroundColor:[VAR_STORE crossIconColor]];
            [cell.itemLabel setText:@"Overdue bills"];
            count = (int)[VAR_STORE overdueCount];
            [cell.countLabel setText:(count > 0) ? [NSString stringWithFormat:@"%d", count] : @"" ];
            break;
/* FIXME to implement
        case 10:
            iconImage = [[UIImage imageNamed:@"list"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [bg setBackgroundColor:[VAR_STORE listIconColor]];
            [cell.icon setBackgroundColor:[VAR_STORE listIconColor]];
            [cell.itemLabel setText:@"Categories"];
            [cell.countLabel setText:@""];
            break;
*/
        case 10:
            iconImage = [[UIImage imageNamed:@"gear"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [bg setBackgroundColor:[VAR_STORE gearIconColor]];
            [cell.icon setBackgroundColor:[VAR_STORE gearIconColor]];
            [cell.itemLabel setText:@"Settings"];
            [cell.countLabel setText:@""];
            break;
        default:
            break;
    }
    [cell.iconImageView setImage:iconImage];
    [cell.iconImageView setTintColor:[VAR_STORE iconTintColor]];
    [cell.itemLabel setFont:[UIFont fontWithName:[VAR_STORE panelDefaultFontName] size:16.0f]];
    [cell.countLabel setFont:[UIFont fontWithName:[VAR_STORE panelDefaultFontName] size:16.0f]];
    [cell setSelectedBackgroundView:bg];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger sectionRow = indexPath.section*10 + indexPath.row;
    switch (sectionRow) {
        case 00:
            [VAR_STORE setCenterViewType:CV_UPCOMING];
            break;
        case 01:
            [VAR_STORE setCenterViewType:CV_PAID];
            break;
        case 02:
            [VAR_STORE setCenterViewType:CV_OVERDUE];
            break;
/* FIXME to implement
        case 10:
            [VAR_STORE setCenterViewType:CV_CATEGORIES];
            break;
*/
        case 10:
            [VAR_STORE setCenterViewType:CV_SETTINGS];
            break;
        default:
            break;
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

@end
