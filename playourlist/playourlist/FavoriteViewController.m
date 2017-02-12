//
//  FavoriteViewController.m
//  playourlist
//
//  Created by Bérangère La Touche on 08/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "FavoriteViewController.h"
#import "CellTableView.h"
#import "VideoViewController.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
{
    NSArray *searchResults;
    VideoViewController* vvc;
}

@end

@implementation FavoriteViewController

@synthesize dataVideoF = dataVideoF_;
@synthesize video_listF = video_listF_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        
        vvc = [[VideoViewController alloc] init];
        
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(touchEdit:)];
        rightItem.tintColor = [UIColor blueColor];
        self.navigationItem.rightBarButtonItem = rightItem;

        [self.tableView reloadData];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];

    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchEdit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResults.count;
    }else {
        return video_listF_.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"CellTableView";
    
    CellTableView* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellTableView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DataVideo* dataVideo = nil;
    if(self.searchController.isActive) {
        dataVideo = [searchResults objectAtIndex:indexPath.row];
    }else {
        dataVideo = [video_listF_ objectAtIndex:indexPath.row];
    }
    
    cell.titleCell.text = dataVideo.title_;
    cell.detailsCell.text = dataVideo.date_;
    NSURL* urlImage = [NSURL URLWithString:dataVideo.thumbnails_];
    NSData* img = [[NSData alloc] initWithContentsOfURL: urlImage];
    cell.thumbnailCell.image = [UIImage imageWithData:img];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoViewController* videoViewController = [[VideoViewController alloc] init];
    DataVideo* data_ = [video_listF_ objectAtIndex:indexPath.row];
    videoViewController.favoriteButton.hidden = YES;
    videoViewController.dataVideo = data_;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title_ contains[c] %@", searchText];
    NSLog(@"%@", [video_listF_ filteredArrayUsingPredicate:predicate]);
    searchResults = [video_listF_ filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSNumber* src = [video_listF_ objectAtIndex:sourceIndexPath.row];
    [video_listF_ removeObjectAtIndex:sourceIndexPath.row];
    [video_listF_ insertObject:src atIndex:destinationIndexPath.row];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [video_listF_ removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
