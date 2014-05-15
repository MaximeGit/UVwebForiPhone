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
        _polls = [[NSMutableArray alloc] init];
    }

    return self;
}

-(id)initWithName:(NSString *)name andTitle:(NSString *)title
{
    if(self = [super init])
    {
        _name = name;
        _title = title;
        _globalRate = [NSNumber numberWithDouble:0];
        _commentCount = [NSNumber numberWithDouble:0];
        _polls = [[NSMutableArray alloc] init];
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

-(NSString *)formattedCeilGlobalRate
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:0];
    [formatter setMinimumFractionDigits:0];
    
    NSNumber* ceilGlobalRate = [NSNumber numberWithInteger:ceil([_globalRate integerValue])];
    
    return [formatter stringFromNumber:ceilGlobalRate];
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
        [uvAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor uvwebColor] range:rangeOfFirstMatch];
    }

    return uvAttributedString;
}

/*
 * Method used to compare two UV global rates.
 * @return : Reversed comparison between both UV global rates.
 */
- (NSComparisonResult)compareReverseGlobalRate:(Uv *)otherUv
{
    return [otherUv.globalRate compare:_globalRate];
}

/*
 * Method used to compare two UV names.
 * @return : Comparison between both UV global rates.
 */
- (NSComparisonResult)compareName:(Uv *)otherUv
{
    return [_name compare:otherUv.name];
}

-(void)addPoll:(Poll*)poll
{
    [_polls addObject:poll];
}

@end
