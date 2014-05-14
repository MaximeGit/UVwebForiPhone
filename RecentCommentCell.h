//
//  RecentCommentCell.h
//  UVweb
//
//  Created by Maxime on 13/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvCommentCell.h"
#import "RecentComment.h"

@interface RecentCommentCell : UvCommentCell

@property (weak, nonatomic) IBOutlet UILabel *uvNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentIdentityLabel;

- (void)configureCellWithRecentComment:(RecentComment*)recentComment;

@end
