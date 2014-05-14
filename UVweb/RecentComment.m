//
//  RecentComment.m
//  UVweb
//
//  Created by Maxime on 12/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "RecentComment.h"

@implementation RecentComment

- (id)initWithComment:(Comment*)comment andUv:(Uv*)uv
{
    if (self = [super init])
    {
        _comment = comment;
        _uv = uv;
    }
    
    return self;
}

- (NSComparisonResult)compareReverseCommentId:(RecentComment*)otherRecentComment
{
    return [_comment compareReverseCommentId:otherRecentComment.comment];
}

@end
