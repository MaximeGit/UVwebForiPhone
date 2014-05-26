//
//  Branch.m
//  UVweb
//
//  Created by Maxime on 25/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "BranchEnum.h"

@implementation BranchEnum

+ (NSString*) stringDefinition:(Branch)branch
{
    switch (branch) {
        case TOUTES:
            return @"Toutes";
        case GI:
            return @"GI";
        case GB:
            return @"GB";
        case GM:
            return @"GM";
        case GP:
            return @"GP";
        case GSM:
            return @"GSM";
        case GSU:
            return @"GSU";
        case TC:
            return @"TC";
        case TSH:
            return @"TSH";
        default:
            return nil;
            break;
    }
}

+ (NSString*) webServiceName:(Branch)branch
{
    switch (branch) {
        case TOUTES:
            return @"all";
        case GI:
            return @"gi";
        case GB:
            return @"gb";
        case GM:
            return @"gm";
        case GP:
            return @"gp";
        case GSM:
            return @"gsm";
        case GSU:
            return @"gsu";
        case TC:
            return @"tc";
        case TSH:
            return @"tsh";
        default:
            return nil;
            break;
    }
}

@end
