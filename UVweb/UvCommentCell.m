//
//  UvCommentCell.m
//  UVweb
//
//  Created by Maxime on 19/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvCommentCell.h"

@implementation UvCommentCell

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
    self.commentIdentityLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentIdentityLabel.frame);
    self.commentSemesterLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentSemesterLabel.frame);
    self.commentGlobalRateLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentGlobalRateLabel.frame);
    self.commentCommentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentCommentLabel.frame);
}

- (void)configureCellWithComment:(Comment*)comment
{
    _commentCommentLabel.text = [comment comment];
    _commentGlobalRateLabel.attributedText = [comment attributedGlobalRate];
    _commentIdentityLabel.text = [comment identity];
    _commentSemesterLabel.text = [comment semester];
}

@end
