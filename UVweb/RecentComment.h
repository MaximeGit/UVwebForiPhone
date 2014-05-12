//
//  RecentComment.h
//  UVweb
//
//  Created by Maxime on 12/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Uv.h"
#import "Comment.h"

@interface RecentComment : NSObject

@property (nonatomic, strong) Uv* uv;
@property (nonatomic, strong) Comment* comment;

- (NSComparisonResult)compareReverseCommentId:(RecentComment*)otherRecentComment;
- (id)initWithComment:(Comment*)comment andUv:(Uv*)uv;

@end
