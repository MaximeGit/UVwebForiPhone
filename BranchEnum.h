//
//  Branch.h
//  UVweb
//
//  Created by Maxime on 25/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BranchEnum : NSObject

typedef enum Branch {
    TOUTES,
    GB,
    GI,
    GM,
    GP,
    GSM,
    GSU,
    TC,
    TSH
} Branch;

+ (NSString*) stringDefinition:(Branch)branch;
+ (NSString*) webServiceName:(Branch)branch;

@end
