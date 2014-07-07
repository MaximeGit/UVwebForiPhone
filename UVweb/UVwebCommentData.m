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

+(NSArray*) mostRecentSemesters
{
    NSMutableArray *semesters = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    int currentMonth = (int)[components month];
    int currentYear = (int)[components year]; // Start with current year

    NSString *currentSemester = @"A";
    
    //Spring semester? => March to end of August
    if (currentMonth > 2 && currentMonth < 9) {
        currentSemester = @"P";
    }
    
    //If beginning of a year (2014): current semester is previous year's number (A13, not A14)
    if ([currentSemester isEqualToString:@"A"] && currentMonth < 3) {
        currentYear = (currentYear - 1);
    }
    
    currentYear %= 100;
    
    for (int i = 0; i < 6; i++)
    {
        if ([currentSemester isEqualToString:@"A"])
        {
            if (i % 2 == 0 && !([semesters count] == 0))
            {
                //2 new semesters were added starting on automn: year--
                currentYear = (currentYear - 1 + 100) % 100;
            }
            
            if (i % 2 == 0)
            {
                [semesters addObject:[NSString stringWithFormat:@"A%i", currentYear]];
            }
            else
            {
                [semesters addObject:[NSString stringWithFormat:@"P%i", currentYear]];
            }
        }
        else
        {
            if (i % 2 == 1 && !([semesters count] == 0))
            {
                //2 new semesters were added starting on spring: year--
                currentYear = (currentYear - 1 + 100) % 100;
            }
            
            if (i % 2 == 1)
            {
                [semesters addObject:[NSString stringWithFormat:@"A%i", currentYear]];
            }
            else
            {
                [semesters addObject:[NSString stringWithFormat:@"P%i", currentYear]];
            }
        }
    }
    
    return semesters;
}

@end
