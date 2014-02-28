//
//  Uv.m
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "Uv.h"

@implementation Uv

-(id)initWithJSONData:(NSDictionary *)UvJSON
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

-(NSString *)getFormattedGlobalRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];

    return [formatter stringFromNumber:_globalRate];
}

-(NSMutableAttributedString *)attributeStringForName
{
    NSMutableAttributedString *uvAttributedString = [[NSMutableAttributedString alloc] initWithString:_name];
    
    //Regex to find the number in the name
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    
    //Getting the range of the number in the name
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:_name options:0 range:NSMakeRange(0, [_name length])];

    //If there is a number, use the range to color it
    if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        UIColor *uvwebColor = [UIColor colorWithRed:114.0/255.0 green:187.0/255.0 blue:170.0/255.0 alpha:100.0];
        [uvAttributedString addAttribute:NSForegroundColorAttributeName value:uvwebColor range:rangeOfFirstMatch];
    }

    return uvAttributedString;
}

@end
