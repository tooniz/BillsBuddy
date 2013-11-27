//
//  BBLeftViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/21/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIViewController+MMDrawerController.h>

@interface BBLeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
