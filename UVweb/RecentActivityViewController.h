//
//  RecentActivityViewController.h
//  UVweb
//
//  Created by Maxime on 12/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Uv.h"
#import "UVwebSessionManager.h"
#import "RecentCommentCell.h"

@interface RecentActivityViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *recentComments;

- (void)reloadDataTable;

@end
