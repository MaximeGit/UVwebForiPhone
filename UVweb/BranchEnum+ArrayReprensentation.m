//
//  BranchEnum+ArrayReprensentation.m
//  UVweb
//
//  Created by Maxime on 26/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "BranchEnum+ArrayReprensentation.h"

@implementation BranchEnum (ArrayReprensentation)

+ (NSArray*) arrayRepresentation
{
    return [NSArray arrayWithObjects:
            [BranchEnum stringDefinition:TOUTES],
            [BranchEnum stringDefinition:GB],
            [BranchEnum stringDefinition:GI],
            [BranchEnum stringDefinition:GM],
            [BranchEnum stringDefinition:GP],
            [BranchEnum stringDefinition:GSM],
            [BranchEnum stringDefinition:GSU],
            [BranchEnum stringDefinition:TC],
            [BranchEnum stringDefinition:TSH],
            nil];
}

@end
