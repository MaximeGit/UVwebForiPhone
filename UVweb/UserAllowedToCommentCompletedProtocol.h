//
//  UserAllowedToCommentCompletedProtocol.h
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserAllowedToCommentCompletedProtocol <NSObject>

@required

-(void)receivedUserCanCommentUvAnswerFromServer:(BOOL)allowed textAnser:(NSString*)answer httpCode:(int)httpCode;

@end