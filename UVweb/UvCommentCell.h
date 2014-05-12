//
//  UvCommentCell.h
//  UVweb
//
//  Created by Maxime on 19/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface UvCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentIdentityLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentSemesterLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentGlobalRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCommentLabel;

- (void)configureCellWithComment:(Comment*)comment;

@end
