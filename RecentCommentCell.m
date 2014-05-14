//
//  RecentCommentCell.m
//  UVweb
//
//  Created by Maxime on 13/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "RecentCommentCell.h"

@implementation RecentCommentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.uvNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.uvNameLabel.frame);
}

- (void)configureCellWithRecentComment:(RecentComment*)recentComment
{
    [super configureCellWithComment:recentComment.comment];
    _uvNameLabel.attributedText = [recentComment.uv attributeStringForName];
}


@end
