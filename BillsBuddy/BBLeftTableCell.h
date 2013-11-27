//
//  BBLeftTableCell.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBLeftTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

+ (CGFloat) getCellHeight;

@end
