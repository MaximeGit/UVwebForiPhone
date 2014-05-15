//
//  Poll.h
//  UVweb
//
//  Created by Maxime on 15/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poll : NSObject

@property (nonatomic, strong) NSNumber *successRate;
@property (nonatomic, strong) NSString *semester;

-(id)initWithJSONData:(NSDictionary *)pollJson;
-(NSString*)formattedSuccessRate;
-(NSString*)formattedPoll;

@end
