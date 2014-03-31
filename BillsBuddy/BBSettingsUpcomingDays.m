//
//  BBSettingsUpcomingDays.m
//  BillsBuddy
//
//  Created by Tony Zhou on 12/8/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBSettingsUpcomingDays.h"

@interface BBSettingsUpcomingDays ()

@property (nonatomic, strong) NSIndexPath *selected;

@end

@implementation BBSettingsUpcomingDays

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSInteger defaultRow;
    if (self.selected != nil)
        defaultRow = self.selected.row;
    else
        switch ([SETTINGS integerForKey:@"upcomingDays"]) {
            case 1:
                defaultRow = 0;
                break;
            case 3:
                defaultRow = 1;
                break;
            case 7:
                defaultRow = 2;
                break;
            case 14:
                defaultRow = 3;
                break;
            case 31:
                defaultRow = 4;
                break;
            case 93:
                defaultRow = 5;
                break;
            default:
                defaultRow = 4;
                DAssert(0, @"invalid upcomingDays setting seen %d", (int)[SETTINGS integerForKey:@"upcomingDays"])
                break;
        }
    if (indexPath.row == defaultRow)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = indexPath;
    NSInteger upcomingDays;
    switch (indexPath.row) {
        case 0:
            upcomingDays = 1;
            break;
        case 1:
            upcomingDays = 3;
            break;
        case 2:
            upcomingDays = 7;
            break;
        case 3:
            upcomingDays = 14;
            break;
        case 4:
            upcomingDays = 31;
            break;
        case 5:
            upcomingDays = 93;
            break;
        default:
            upcomingDays = 31;
            break;
    }
    [SETTINGS setInteger:upcomingDays forKey:@"upcomingDays"];
    [SETTINGS synchronize];
    [tableView reloadData];
    [VAR_STORE setRefetchNeeded:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
