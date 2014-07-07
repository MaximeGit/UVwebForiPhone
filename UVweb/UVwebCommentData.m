//
//  UVwebCommentEnums.m
//  UVweb
//
//  Created by Maxime on 05/07/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UVwebCommentData.h"

@implementation UVwebCommentData

+(NSArray*) interestPedagogyData
{
    return @[
             @"Nul",
             @"Bof",
             @"Peu intéressant",
             @"Intéressant",
             @"Très intéressant",
             @"Passionnant"
             ];
}

+(NSArray*) utilityData
{
    return @[
             @"Inutile",
             @"Bof",
             @"Peu intéressant",
             @"Intéressant",
             @"Très intéressant",
             @"Passionnant"
             ];
}

+(NSArray*) workAmountData
{
    return @[@"Symbolique",
             @"Faible",
             @"Moyenne",
             @"Importante",
             @"Très importante"
             ];
}

@end
