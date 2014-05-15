//
//  Poll.m
//  UVweb
//
//  Created by Maxime on 15/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "Poll.h"

@implementation Poll

-(id)initWithJSONData:(NSDictionary *)pollJson
{
    if(self = [super init])
    {
        _successRate = [NSNumber numberWithDouble:[pollJson[@"successRate"] doubleValue]];
        _semester = [NSString stringWithFormat:@"%c%d", [pollJson[@"season"] characterAtIndex:0], [pollJson[@"year"] intValue] % 100];
    }
    
    return self;
}

-(NSString*)formattedSuccessRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    
    return [formatter stringFromNumber:_successRate];
}

-(NSString*)formattedPoll
{
    NSString *stringPoll = [self formattedSuccessRate];
    
    stringPoll = [stringPoll stringByAppendingString:@"%("];
    stringPoll = [stringPoll stringByAppendingString:_semester];
    stringPoll = [stringPoll stringByAppendingString:@")"];
    
    return stringPoll;
}

@end
