//
//  BBLeftTableCell.m
//  BillsBuddy
//
//  Created by Tony Zhou on 11/25/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import "BBLeftTableCell.h"

@implementation BBLeftTableCell

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
    self.icon.layer.cornerRadius = 6; // this value vary as per your desire
    self.icon.clipsToBounds = YES;
    self.itemLabel.adjustsFontSizeToFitWidth = YES;
}

+ (CGFloat) getCellHeight {
    return 50;
}

@end
