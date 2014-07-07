//
//  UvTitleCellWithPolls.m
//  UVweb
//
//  Created by Maxime on 15/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvTitleCellWithPolls.h"

@implementation UvTitleCellWithPolls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 * Make sure height after device rotation will be recalculated correctly
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.uvPollsLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.uvPollsLabel.frame);
}

- (void) configureCellWithUv:(Uv*)uv
{
    [super configureCellWithUv:uv];
    
    int pollCount = (int)[uv.polls count];
    
    if(pollCount == 0)
    {
        return;
    }
    
    _uvPollsLabel.text = @"Réussite : ";
    
    for (int i = 0; i < pollCount; i++)
    {
        Poll *poll = [uv.polls objectAtIndex:i];
        
        _uvPollsLabel.text = [_uvPollsLabel.text stringByAppendingString:[poll formattedPoll]];
        
        if([uv.polls lastObject] != poll)
        {
            _uvPollsLabel.text = [_uvPollsLabel.text stringByAppendingString:@" | "];
        }
    }
}


@end
