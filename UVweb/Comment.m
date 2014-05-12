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

@end
