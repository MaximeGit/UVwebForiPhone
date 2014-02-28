//
//  UVwebSessionManager.h
//  UVweb
//
//  Created by Maxime on 08/12/2013.
//  Copyright (c) 2013 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"

@interface UVwebSessionManager : NSObject

@property(nonatomic, strong) NSMutableString *uvwebBaseUrl;
@property(nonatomic, weak) NSURLSession *session;

- (id)initWithBaseurl:(NSString *) baseUrl;
- (void)getAllUvsAndRefreshTable:(UITableView*)table uvs:(OrderedDictionary*)uvs;

@end
