//
//  BBCenterTableCell.h
//  BillsBuddy
//
//  Created by Tony Zhou on 11/23/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SWTableViewCell.h>

@interface BBCenterTableCell : UITableViewCell

+ (CGFloat) getCellHeight;

@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (weak, nonatomic) IBOutlet UILabel *itemText;
@property (weak, nonatomic) IBOutlet UILabel *frequencyText;
@property (weak, nonatomic) IBOutlet UILabel *deadlineText;
@property (weak, nonatomic) IBOutlet UILabel *amountText;


@end
