//
//  BBCenterTableCell.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/23/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBCenterTableCell.h"

@implementation BBCenterTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) getCellHeight {
    return 60;
}

@end
