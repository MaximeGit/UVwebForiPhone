//
//  Comment.m
//  UVweb
//
//  Created by Maxime on 19/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(id)initWithJSONData:(NSDictionary *)commentJSON
{
    if(self = [super init])
    {
        _identity = commentJSON[@"identity"];
        _comment = commentJSON[@"comment"];
        _semester = commentJSON[@"semester"];
        _globalRate = [NSNumber numberWithDouble:[commentJSON[@"globalRate"] doubleValue]];
        _commentId = [NSNumber numberWithDouble:[commentJSON[@"id"] integerValue]];
    }
    
    return self;
}

-(NSString *)getFormattedGlobalRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    return [formatter stringFromNumber:_globalRate];
}

-(NSComparisonResult)compareReverseCommentId:(Comment*)otherComment
{
    return [otherComment.commentId compare:_commentId];
}

-(NSComparisonResult)compareCommentId:(Comment*)otherComment
{
    return [_commentId compare:otherComment.commentId];
}

-(NSMutableAttributedString*)attributedGlobalRate
{
    NSMutableAttributedString *attributedGlobalRate = [[NSMutableAttributedString alloc] initWithString:[_globalRate stringValue]];
    
    NSRange range = NSMakeRange(0, [attributedGlobalRate length]);
    
    UIColor *color;

    if([_globalRate integerValue] < 4)
    {
        color = [UIColor redColor];
    }
    else if([_globalRate integerValue] > 6)
    {
        color = [UIColor uvwebColor];
    }
    else
    {
        return attributedGlobalRate;
    }
    
    [attributedGlobalRate addAttribute:NSForegroundColorAttributeName value:color range:range];

    return attributedGlobalRate;
}

@end
