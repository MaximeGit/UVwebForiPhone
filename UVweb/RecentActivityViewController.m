//
//  RecentActivityViewController.m
//  UVweb
//
//  Created by Maxime on 12/05/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "RecentActivityViewController.h"

@interface RecentActivityViewController ()

@property (strong, nonatomic) UVwebSessionManager *sessionManager;
@property (strong, nonatomic) UvCommentCell *prototypeCommentCell;

@end

@implementation RecentActivityViewController

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
    
    _sessionManager = [UVwebSessionManager sharedSessionManager];
    _recentComments = [[NSMutableArray alloc] init];
    
    [_sessionManager recentActivity:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recentComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"UvComment";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RecentComment* recentComment = [_recentComments objectAtIndex:indexPath.row];
    
    [(UvCommentCell*)cell configureCellWithComment:recentComment.comment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentComment *recentComment = [_recentComments objectAtIndex:indexPath.row];
    [self.prototypeCommentCell configureCellWithComment:[recentComment comment]];
    self.prototypeCommentCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCommentCell.bounds));
    [self.prototypeCommentCell layoutIfNeeded];
    CGSize size = [self.prototypeCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height+1;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"uvDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        
        UvDetailsViewController *destinationController = (UvDetailsViewController*)segue.destinationViewController;
        
        Uv *selectedUv = [[_recentComments objectAtIndex:indexPath.row] uv];
        
        [destinationController prepareWithUv:selectedUv];
    }
}

- (UvCommentCell *)prototypeCommentCell
{
    static NSString *CellIdentifier = @"UvComment";
    
    if (!_prototypeCommentCell)
    {
        _prototypeCommentCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _prototypeCommentCell;
}

@end
