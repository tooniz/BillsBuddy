//
//  BBSettingsNotifications.m
//  BillsBuddy
//
//  Created by Tony Zhou on 12/8/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBSettingsNotifications.h"

@interface BBSettingsNotifications ()

@property (nonatomic, strong) NSIndexPath *selected;
@property (nonatomic) NSInteger currentHour;

@end

@implementation BBSettingsNotifications

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
    
    int hour = (int)[SETTINGS integerForKey:@"scheduledReminderHour"];
    self.currentHour = hour;
    self.slider.value = (float)hour;
    self.sliderLabel.text = StringGen(@"Trigger reminders at %d:00%@", (hour==0 || hour==12) ? 12 : hour<12 ? hour : hour-12, hour<12 ? @"AM" : @"PM");

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

    if (indexPath.section == 1) {
        if (self.selected != nil)
            defaultRow = self.selected.row;
        else
            switch ([SETTINGS integerForKey:@"notificationDays"]) {
                case -3:
                    defaultRow = 0;
                    break;
                case -1:
                    defaultRow = 1;
                    break;
                case 0:
                    defaultRow = 2;
                    break;
                default:
                    defaultRow = 2;
                    DAssert(0, @"invalid notificationDays setting seen %d", (int)[SETTINGS integerForKey:@"notificationDays"])
                    break;
            }
        if (indexPath.row == defaultRow)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = indexPath;

    NSInteger originalDays = [SETTINGS integerForKey:@"notificationDays"];
    NSInteger notificationDays = originalDays;
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                notificationDays = -3;
                break;
            case 1:
                notificationDays = -1;
                break;
            case 2:
                notificationDays = 0;
                break;
            default:
                notificationDays = 0;
                break;
        }
        [SETTINGS setInteger:notificationDays forKey:@"notificationDays"];
    }
    [SETTINGS synchronize];
    [tableView reloadData];
    
    NSInteger delta = notificationDays - originalDays;
    if (delta != 0) {
        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString *notificationId = [notification.userInfo objectForKey:@"id"];
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            DLog(@"just cancelled notification: \n%@", notification.description);
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offset = [[NSDateComponents alloc] init];
            [offset setDay:delta];
            notification.fireDate = [calendar dateByAddingComponents:offset toDate:notification.fireDate options:0];
            [BBMethodStore scheduleNotificationForDate:notification.fireDate
                                             AlertBody:notification.alertBody
                                     ActionButtonTitle:notification.alertAction
                                        RepeatInterval:notification.repeatInterval
                                        NotificationID:notificationId];
        }
    }
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

- (IBAction)sliderValueChanged:(id)sender {
    int hour = (int)self.slider.value;

    if (self.currentHour != hour) {
        [SETTINGS setInteger:(NSInteger)self.slider.value forKey:@"scheduledReminderHour"];
        [SETTINGS synchronize];
        
        hour = (int)self.slider.value;
        self.currentHour = hour;
        self.sliderLabel.text = StringGen(@"Trigger reminders at %d:00%@", (hour==0 || hour==12) ? 12 : hour<12 ? hour : hour-12, hour<12 ? @"AM" : @"PM");
        for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString *notificationId = [notification.userInfo objectForKey:@"id"];
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            DLog(@"just cancelled notification: \n%@", notification.description);
            notification.fireDate = [BBMethodStore beginningOfDay:notification.fireDate plusHours:hour];
            [BBMethodStore scheduleNotificationForDate:notification.fireDate
                                             AlertBody:notification.alertBody
                                     ActionButtonTitle:notification.alertAction
                                        RepeatInterval:notification.repeatInterval
                                        NotificationID:notificationId];
        }
    }
}

@end
