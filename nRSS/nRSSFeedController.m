//
//  nRSSFeedController.m
//  nRSS
//
//  Created by Nico Naegele on 4/1/13.
//  Copyright (c) 2013 n2305. All rights reserved.
//

#import "nRSSFeedController.h"
#import "FeedBinApiClient.h"
#import "nRSSWebViewController.h"
#import "SVPullToRefresh.h"

@interface nRSSFeedController ()
@property (strong, nonatomic) NSMutableArray* webViewControllers;
@property NSInteger lastLoadedPage;
@property NSInteger currentEntryIndex;
@end

@implementation nRSSFeedController

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
    self.entries = [[NSArray alloc] init];
    self.webViewControllers = [[NSMutableArray alloc] init];
    self.title = [self.feed objectForKey:@"title"];
    [self loadEntries];

    __weak nRSSFeedController* weakSelf = self;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadEntries];
    }];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadNextEntries];
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadEntries
{
    FeedBinApiClient* apiClient = [FeedBinApiClient sharedInstance];
    [apiClient getPath:[NSString stringWithFormat:@"feeds/%@/entries.json", self.feed[@"feed_id"]]
            parameters:@{@"include_entry_state": @"true"}
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   self.entries = responseObject;
                   [self.tableView reloadData];
                   [self.tableView.pullToRefreshView stopAnimating];
                   self.lastLoadedPage = 1;
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error %@", error);
               }];
}

- (void)loadNextEntries
{
    if ([self.entries count] % 100 != 0) {
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    
    FeedBinApiClient* apiClient = [FeedBinApiClient sharedInstance];
    [apiClient getPath:[NSString stringWithFormat:@"feeds/%@/entries.json", self.feed[@"feed_id"]] parameters:@{@"include_entry_state": @"true", @"page": @2} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.entries = [self.entries arrayByAddingObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        self.lastLoadedPage = self.lastLoadedPage + 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* entry = self.entries[indexPath.row];
    cell.textLabel.text = [entry objectForKey:@"title"];
    cell.detailTextLabel.text = [entry objectForKey:@"published"];
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nRSSWebViewController* webViewController = [self instantiateWebViewControllerForFeedEntry:self.entries[indexPath.row]];
    self.currentEntryIndex = indexPath.row;
    [self.navigationController pushViewController:webViewController animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (nRSSWebViewController*)instantiateWebViewControllerForFeedEntry:(NSDictionary*)feedEntry {
    nRSSWebViewController* webViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"nRSSWebViewController"];
    webViewController.feedManagerDelegate = self;
    [webViewController prepareWebViewForFeedEntry:feedEntry];
    return webViewController;
}

- (void)loadNextEntry
{
    [self.navigationController popToViewController:self animated:NO];
    self.currentEntryIndex = self.currentEntryIndex + 1;
    nRSSWebViewController* newWebViewController = [self instantiateWebViewControllerForFeedEntry:self.entries[self.currentEntryIndex]];
    [self.navigationController pushViewController:newWebViewController animated:NO];
}

@end
