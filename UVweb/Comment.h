//
//  Comment.h
//  UVweb
//
//  Created by Maxime on 19/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, strong, readonly) NSString *identity;
@property (nonatomic, strong, readonly) NSString *semester;
@property (nonatomic, strong, readonly) NSNumber *globalRate;
@property (nonatomic, strong, readonly) NSNumber *commentId;
@property (nonatomic, strong, readonly) NSString *comment;

-(id)initWithJSONData:(NSDictionary *)commentJSON;
-(NSString *)getFormattedGlobalRate;

@end
