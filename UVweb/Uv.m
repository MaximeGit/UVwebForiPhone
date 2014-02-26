//
//  Uv.m
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "Uv.h"

@implementation Uv

-(id) initWithJSONData:(NSDictionary*)UvJSON
{
    if(self = [super init])
    {
        _name = UvJSON[@"name"];
        _title = UvJSON[@"title"];
        _globalRate = [NSNumber numberWithDouble:[UvJSON[@"globalRate"] doubleValue]];
        _commentCount = [NSNumber numberWithDouble:[UvJSON[@"commentCount"] doubleValue]];
    }
    
    return self;
}

-(NSString*) getFormattedGlobalRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];

    return [formatter stringFromNumber:_globalRate];
}

@end
