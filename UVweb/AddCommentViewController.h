//
//  AddCommentViewController.h
//  UVweb
//
//  Created by Maxime on 25/06/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

@class AddCommentViewController;

@protocol AddCommentViewControllerDelegate <NSObject>

- (void)addCommentViewControllerDidCancel:(AddCommentViewController*)controller;
- (void)addCommentViewControllerDidAddComment:(AddCommentViewController*)controller;

@end

#import <UIKit/UIKit.h>
#import "UvwebCommentData.h"
#import "UIColor+CustomColors.h"
#import "UVwebSessionManager.h"
#import "Uv.h"

@interface AddCommentViewController : UITableViewController <UIActionSheetDelegate, UITextViewDelegate, CommentSentToServerReplyDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<AddCommentViewControllerDelegate> delegate;

@property (nonatomic, strong) Uv* uv;

//User credentials to send new comment to server
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;

//______________________________________________
//UI References

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *globalRateTextField;

//Sliders
@property (weak, nonatomic) IBOutlet UISlider *interestSlider;
@property (weak, nonatomic) IBOutlet UISlider *pedagogySlider;
@property (weak, nonatomic) IBOutlet UISlider *utilitySlider;
@property (weak, nonatomic) IBOutlet UISlider *workAmountSlider;

//Text fields linked to sliders
@property (weak, nonatomic) IBOutlet UITextField *interestTextField;
@property (weak, nonatomic) IBOutlet UITextField *pedagogyTextField;
@property (weak, nonatomic) IBOutlet UITextField *utilityTextField;
@property (weak, nonatomic) IBOutlet UITextField *workAmountTextField;

//Labels linked to sliders
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UILabel *pedagogyLabel;
@property (weak, nonatomic) IBOutlet UILabel *utilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *workAmountLabel;

//UI buttons
@property (weak, nonatomic) IBOutlet UIButton *semesterButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *obtainedUvSegmentedControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *validateCommentButton;


- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

//Semester action sheet method
- (IBAction)showSemesterActionSheet:(id)sender;

@end