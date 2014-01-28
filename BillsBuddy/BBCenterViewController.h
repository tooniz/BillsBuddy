//
//  BBCenterViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/14/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <SWTableViewCell.h>

@interface BBCenterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>


@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *numBillsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *billsClearedImage;

- (IBAction)didTapAdd:(id)sender;

- (void) updateView;

@end
