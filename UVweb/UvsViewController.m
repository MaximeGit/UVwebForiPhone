//
//  UvsViewController.m
//  UVweb
//
//  Created by Maxime on 27/01/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvsViewController.h"
#import "UVwebSessionManager.h"
#import "Uv.h"

@interface UvsViewController ()

@property (nonatomic, strong) UVwebSessionManager *session;

@end

@implementation UvsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    

    self.clearsSelectionOnViewWillAppear = NO;
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + _uvSearchBar.bounds.size.height;
    self.tableView.bounds = newBounds;

    _session = [UVwebSessionManager sharedSessionManager];

    _orderedUVs = [[OrderedDictionary alloc] init];
    _filteredUVs = [[OrderedDictionary alloc] init];
    
    //Adapting the height of the search bar
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];

    //Preparing the sort chooser
    [self.sortSegmentedControl addTarget:self action:@selector(didPressSortType:) forControlEvents:UIControlEventValueChanged];
    
    //By default, all uvs are displayed in alphabetical order
    _currentBranch = TOUTES;
    
    //Refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //Getting UVs from web service
    [self refreshTable];
    
    [[UITableView appearance] setTintColor:[UIColor uvwebColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UvCell";
    
    UITableViewCell *cell = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    else
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Uv* uv = nil;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        uv = [[_filteredUVs objectForKey:[_filteredUVs keyAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    else
        uv = [[_orderedUVs objectForKey:[_orderedUVs keyAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.attributedText = [uv attributeStringForName];
    
    UILabel *globalRateLabel = (UILabel *)[cell viewWithTag:101];
    globalRateLabel.text = [uv getFormattedGlobalRate];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:102];
    titleLabel.text = uv.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [[_filteredUVs allKeys] count];
    else
        return [[_orderedUVs allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [[_filteredUVs valueForKey:[_filteredUVs keyAtIndex:section]] count];
    else
        return [[_orderedUVs valueForKey:[_orderedUVs keyAtIndex:section]] count];
}
 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [_filteredUVs allKeysSorted];
    else
        return [_orderedUVs allKeysSorted];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerCellIdentifier = @"UvLetterHeaderCell";
    
    UITableViewCell* headerCell = [self.tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
    
    UILabel *letterLabel = (UILabel *)[headerCell viewWithTag:100];
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
        letterLabel.text = [_filteredUVs keyAtIndex:section];
    else
        letterLabel.text = [_orderedUVs keyAtIndex:section];
    
    return headerCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [_filteredUVs removeAllObjects];
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];

    for (NSString * uvLetter in _orderedUVs) {
        NSMutableArray *arr = [_orderedUVs valueForKey:uvLetter];
        NSArray *sortedArr = [arr filteredArrayUsingPredicate:predicate];
        
        if ([sortedArr count]) {
            [_filteredUVs setObject:sortedArr forKey:uvLetter];
        }
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
 * Starts the search option in the list
 */
-(IBAction)startSearch:(id)sender
{
    [_uvSearchBar becomeFirstResponder];
}

/*
 * Triggered when a sort type is selected: have to sort the UVs accordingly
 * selectedSegmentIndex == 0 if user wants sorted by name. selectedSegmentIndex == 1 if user wants sorted by global rate.
 */
-(void)didPressSortType:(id)sender
{
    //Dictionary containing the updated model
    OrderedDictionary* newOrderedUvs = [[OrderedDictionary alloc] init];
    
    if([(UISegmentedControl*) sender selectedSegmentIndex] == 0)
    {
        //Sort by name
        for (NSString *groupRate in _orderedUVs)
        {
            NSArray *rateUvs = _orderedUVs[groupRate];
            
            for (Uv* uv in rateUvs)
            {
                //First letter of the UV name
                NSString* uvLetter = [uv.name substringToIndex:1];
                
                //Does the rate exist in the keys of the dictionary?
                if(![newOrderedUvs objectForKey:uvLetter])
                {
                    [newOrderedUvs setObject:[[NSMutableArray alloc] init] forKey:uvLetter];
                }
                [[newOrderedUvs objectForKey:uvLetter] addObject:uv];
            }
        }
        
        //Need to sort the NSMutableDictionary keys as they were not ordered in the JSON
        [newOrderedUvs sortKeysUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        for (NSString *groupLetter in newOrderedUvs)
        {
            NSMutableArray *letterUvs = newOrderedUvs[groupLetter];
            letterUvs = [letterUvs sortedArrayUsingSelector:@selector(compareName:)];
            [newOrderedUvs setObject:letterUvs forKey:groupLetter];
        }

    }
    else
    {
        for (NSString *groupLetter in _orderedUVs)
        {
            NSArray *letterUvs = _orderedUVs[groupLetter];
            for (Uv* uv in letterUvs)
            {
                //We need rates as integers so that no crash will occur
                NSString* ceilGlobalRate = [uv formattedCeilGlobalRate];
                
                //Does the rate exist in the keys of the dictionary?
                if(![newOrderedUvs objectForKey:ceilGlobalRate])
                {
                    [newOrderedUvs setObject:[[NSMutableArray alloc] init] forKey:ceilGlobalRate];
                }
                [[newOrderedUvs objectForKey:ceilGlobalRate] addObject:uv];
            }
        }
        
        //Need to sort the NSMutableDictionary keys as they were not ordered in the JSON
        [newOrderedUvs sortKeysUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"doubleValue" ascending:NO]]];

        for (NSString *integerRate in newOrderedUvs)
        {
            NSMutableArray *rateUvs = newOrderedUvs[integerRate];
            rateUvs = [rateUvs sortedArrayUsingSelector:@selector(compareReverseGlobalRate:)];
            [newOrderedUvs setObject:rateUvs forKey:integerRate];
        }
    }
    
    _orderedUVs = newOrderedUvs;

    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"uvDetails"])
    {
        // Sender is the table view cell.
        OrderedDictionary *sourceDictionary;
        
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:(UITableViewCell *)sender];
        
        if (indexPath != nil)
        {
            sourceDictionary = _filteredUVs;
        }
        else
        {
            indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
            sourceDictionary = _orderedUVs;
        }
        
        UvDetailsViewController *destinationController = (UvDetailsViewController*)segue.destinationViewController;
        
        Uv *selectedUv = [[sourceDictionary objectForKey:[sourceDictionary keyAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        destinationController.uv = selectedUv;
    }
}

- (void)refreshTable
{
    [_session uvsOfBranch:_currentBranch forTableViewController:self];
}

- (void)reloadDataTable
{
    if([self.refreshControl isRefreshing])
    {
        [self.refreshControl endRefreshing];
    }
    
    //Set name sort after loading data
    _sortSegmentedControl.selectedSegmentIndex = 0;
    
    [self.tableView reloadData];
}

//Action sheet to chose a branch (GB, GI...)
- (IBAction)showBranchActionSheet:(id)sender
{
    UIActionSheet *branchActionSheet = [[UIActionSheet alloc] initWithTitle:@"Branche"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil];
    
    NSArray *branchNameArray = [BranchEnum arrayRepresentation];
    
    for (NSString* branchName in branchNameArray) {
        [branchActionSheet addButtonWithTitle:branchName];
    }
    
    [branchActionSheet addButtonWithTitle:@"Annuler"];
    branchActionSheet.cancelButtonIndex = [branchNameArray count];

    [branchActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == _currentBranch || [[BranchEnum arrayRepresentation] count] == buttonIndex) {
        return;
    }
    
    //Stop the table scrolling
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    
    _currentBranch = buttonIndex;
    [_branchButton setTitle:[BranchEnum stringDefinition:buttonIndex]];
    [self refreshTable];
}

/**
 * Green UVweb color for action sheet buttons
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor uvwebColor] forState:UIControlStateHighlighted];
        }
    }
}

@end
