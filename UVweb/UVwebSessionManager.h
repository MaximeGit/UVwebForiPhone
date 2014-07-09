//
//  UVwebSessionManager.h
//  UVweb
//
//  Created by Maxime on 08/12/2013.
//  Copyright (c) 2013 UVweb. All rights reserved.
//

@protocol CommentSentToServerReplyDelegate <NSObject, NSURLSessionTaskDelegate, NSURLSessionDelegate>

@required

- (void)serverDidNotAcceptComment:(int)statusCode answer:(NSString*)answer;
- (void)serverDidAcceptComment;

@end

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

//Comment management
- (void)sendCommentToServer:(NSDictionary*)newComment username:(NSString*)username password:(NSString*)password uv:(Uv*)uv delegate:(id <CommentSentToServerReplyDelegate>)delegate;

+ (UVwebSessionManager*) sharedSessionManager;

@end