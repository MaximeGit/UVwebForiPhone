//
//  UvsViewController.h
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderedDictionary.h"
#import "UvDetailsViewController.h"
#import "BranchEnum.h"
#import "BranchEnum+ArrayReprensentation.h"

@interface UvsViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) OrderedDictionary *orderedUVs;
@property (nonatomic, strong) OrderedDictionary *filteredUVs;

//Searchbar outlet
@property IBOutlet UISearchBar *uvSearchBar;

//Segmented control outlet to choose the sort type (by rate or by name)
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

//Branch related attributes
@property (weak, nonatomic) IBOutlet UIBarButtonItem *branchButton;
@property (nonatomic) Branch currentBranch;

@property (weak, nonatomic) NSMutableString *currentOrder;

-(IBAction)startSearch:(id)sender;
-(void)didPressSortType:(id)sender;

- (void)reloadDataTable;

//Action sheet trigger method
- (IBAction)showBranchActionSheet:(id)sender;

@end
