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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _filteredUVs = [[OrderedDictionary alloc] init];
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];

    [self downloadUvs];
}

- (void)downloadUvs
{
    _session = [[UVwebSessionManager alloc] initWithBaseurl:@""];
    
    _orderedUVs = [[OrderedDictionary alloc] init];
    
    [_session getAllUvsAndRefreshTable:self.tableView uvs:_orderedUVs];
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
    nameLabel.text = uv.name;
    
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

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
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

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
 
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
