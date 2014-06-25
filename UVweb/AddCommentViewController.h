//
//  AddCommentViewController.h
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddCommentViewController;

@protocol AddCommentViewControllerDelegate <NSObject>

- (void)addCommentViewControllerDidCancel:(AddCommentViewController*)controller;
- (void)addCommentViewControllerDidSave:(AddCommentViewController*)controller;

@end

@interface AddCommentViewController : UITableViewController

@property (nonatomic, weak) id<AddCommentViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
