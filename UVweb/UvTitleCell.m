//
//  UvTitleCell.m
//  UVweb
//
//  Created by Maxime on 18/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvTitleCell.h"

@implementation UvTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 * Make sure height after device rotation will be recalculated correctly
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    self.uvTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.uvTitleLabel.frame);
}

- (void) configureCellWithUv:(Uv*)uv
{
    _uvTitleLabel.text = uv.title;
    _uvInfoLabel.text = @"TP : ";
    
    if(uv.hasTp == YES)
    {
        _uvInfoLabel.text = [_uvInfoLabel.text stringByAppendingString:@"Oui"];
    }
    else
    {
        _uvInfoLabel.text = [_uvInfoLabel.text stringByAppendingString:@"Non"];
    }
    
    _uvInfoLabel.text = [_uvInfoLabel.text stringByAppendingString:@" | Final : "];

    if(uv.hasFinal == YES)
    {
        _uvInfoLabel.text = [_uvInfoLabel.text stringByAppendingString:@"Oui"];
    }
    else
    {
        _uvInfoLabel.text = [_uvInfoLabel.text stringByAppendingString:@"Non"];
    }
}

@end
