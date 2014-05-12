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

@interface UvsViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) OrderedDictionary *orderedUVs;
@property (nonatomic, strong) OrderedDictionary *filteredUVs;
@property IBOutlet UISearchBar *uvSearchBar;

//Segmented control outlet to choose the sort type (by rate or by name)
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

-(IBAction)startSearch:(id)sender;
-(void)didPressSortType:(id)sender;

@end
