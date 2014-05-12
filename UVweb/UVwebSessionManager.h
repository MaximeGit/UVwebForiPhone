//
//  UVwebSessionManager.h
//  UVweb
//
//  Created by Maxime on 08/12/2013.
//  Copyright (c) 2013 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"
#import "Uv.h"
#import "Comment.h"

@interface UVwebSessionManager : NSObject

@property(nonatomic, strong) NSMutableString *uvwebBaseUrl;

- (void)getAllUvsAndRefreshTable:(UITableView*)table uvs:(OrderedDictionary*)uvs;
- (void)uvDetails:(Uv*)uv forTable:(UITableView*)table uvComments:(NSMutableArray*)uvComments;

+ (UVwebSessionManager*) sharedSessionManager;

@end