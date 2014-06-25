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
#import "RecentActivityViewController.h"
#import "RecentComment.h"
#import "UvDetailsViewController.h"
#import "UvsViewController.h"
#import "Poll.h"
#import "BranchEnum.h"
#import "UserAllowedToCommentCompletedProtocol.h"

@interface UVwebSessionManager : NSObject

@property(nonatomic, strong) NSMutableString *uvwebBaseUrl;

- (void)uvDetails:(Uv*)uv forViewController:(UITableViewController*)tableViewController;
- (void)recentActivity:(UITableViewController*)recentActivityViewController;
- (void)uvsOfBranch:(Branch)branch forTableViewController:(UITableViewController*)tableViewController;
- (void)userAllowedToCommentUv:(Uv*)uv username:(NSString*)username password:(NSString*)password delegate:(id <UserAllowedToCommentCompletedProtocol>)delegate;

+ (UVwebSessionManager*) sharedSessionManager;

@end