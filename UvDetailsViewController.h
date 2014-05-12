//
//  UvDetailsViewController.h
//  UVweb
//
//  Created by Maxime on 03/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Uv.h"
#import "UVwebSessionManager.h"
#import "UvTitleCell.h"
#import "UvCommentCell.h"

@interface UvDetailsViewController : UITableViewController

@property(strong, nonatomic) Uv *uv;

- (void) prepareWithUv:(Uv*)uv;

@end
