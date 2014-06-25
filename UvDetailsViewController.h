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
#import "UvTitleCellWithPolls.h"
#import "UvCommentCell.h"
#import "UserAllowedToCommentCompletedProtocol.h"
#import "UvwebCredentialsAlertView.h"

@interface UvDetailsViewController : UITableViewController <UIAlertViewDelegate, UserAllowedToCommentCompletedProtocol>

@property(strong, nonatomic) Uv *uv;
@property (strong, nonatomic) NSMutableArray *uvComments;

//Button to add a comment
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCommentButton;

- (IBAction)addCommentAction:(id)sender;

- (void)reloadDataTable;

@end
