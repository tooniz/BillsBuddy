//
//  BBCenterViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBCenterViewController : UITableViewController <UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTapAdd:(id)sender;

- (void) updateView;

@end
