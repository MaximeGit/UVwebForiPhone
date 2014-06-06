//
//  UvDetailsViewController.m
//  UVweb
//
//  Created by Maxime on 03/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import "UvDetailsViewController.h"

@interface UvDetailsViewController ()

@property (strong, nonatomic) UVwebSessionManager *sessionManager;
@property (strong, nonatomic) UvTitleCell *prototypeTitleCell;
@property (strong, nonatomic) UvTitleCellWithPolls *prototypeTitleCellWithPolls;
@property (strong, nonatomic) UvCommentCell *prototypeCommentCell;

@end

@implementation UvDetailsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        _sessionManager = [UVwebSessionManager sharedSessionManager];
        _uvComments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //Refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [_sessionManager uvDetails:_uv forViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [_uvComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(indexPath.row == 0)
    {
        //First cell : title of the UV
        static NSString *CellIdentifier = @"UvTitle";
        
        if([_uv.polls count] > 0)
        {
            CellIdentifier = @"UvTitleWithPolls";
        }
        else
        {
            CellIdentifier = @"UvTitle";
        }

        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [(UvTitleCell*)cell configureCellWithUv:_uv];
    }
    else
    {
        //Comment of the UV
        static NSString *CellIdentifier = @"UvComment";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        Comment *comment = [_uvComments objectAtIndex:indexPath.row -1];
        
        [(UvCommentCell*)cell configureCellWithComment:comment];
    }
    
    return cell;
}

- (UvTitleCell *)prototypeTitleCell
{
    static NSString *CellIdentifier = @"UvTitle";
    
    if([_uv.polls count] > 0)
    {
        CellIdentifier = @"UvTitleWithPolls";
        
        if (!_prototypeTitleCellWithPolls)
        {
            _prototypeTitleCellWithPolls = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        return _prototypeTitleCellWithPolls;
    }
    else
    {
        CellIdentifier = @"UvTitle";
    }
    
    if (!_prototypeTitleCell)
    {
        _prototypeTitleCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    return _prototypeTitleCell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        //First cell : title of the UV
        [self.prototypeTitleCell configureCellWithUv:_uv];
        
        self.prototypeTitleCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeTitleCell.bounds));
        [self.prototypeTitleCell layoutIfNeeded];
        CGSize size = [self.prototypeTitleCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return size.height+1;
    }
    else
    {
        [self.prototypeCommentCell configureCellWithComment:[_uvComments objectAtIndex:indexPath.row - 1]];
        self.prototypeCommentCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCommentCell.bounds));
        [self.prototypeCommentCell layoutIfNeeded];
        CGSize size = [self.prototypeCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return size.height+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)refreshTable
{
    [_sessionManager uvDetails:_uv forViewController:self];
}

- (void)reloadDataTable
{
    if([self.refreshControl isRefreshing])
    {
        [self.refreshControl endRefreshing];
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ | %@", [_uv name], [_uv getFormattedGlobalRate]];
    [self.tableView reloadData];
}

@end
