//
//  ListViewController.m
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ListViewController.h"
#import "APIKey.h"
#import "DataVideo.h"
#import "CellTableView.h"
#import "VideoViewController.h"
#import "FavoriteViewController.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>
{
    NSMutableArray<DataVideo*> *video_list ;
    NSArray *searchResults;
    FavoriteViewController* favoriteViewController;
    VideoViewController* videoViewController;
}
@end

@implementation ListViewController

@synthesize fVideo = fVideo_;
@synthesize fVideoArray = fVideoArray_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        NSLog(@"init");
        
        self.title = @"Play Your List";
        
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(touchFavorite:)];
        rightItem.tintColor = [UIColor grayColor];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        video_list = [[NSMutableArray<DataVideo*> alloc] init];
        self.fVideoArray = [[NSMutableArray<DataVideo*> alloc] init];
        //videoViewController = [[VideoViewController alloc] init];
        //favoriteViewController = [[FavoriteViewController alloc] init];
        
        NSURLSession* urlSession = [NSURLSession sharedSession];
        NSString *urlString = [NSString stringWithFormat: @"https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&maxResults=50&key=%@", APIKey];
        //NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&key=%@",APIKey];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                
            if(!error) {
                NSError* error = nil;
                NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
                NSMutableArray* videos = [NSMutableArray arrayWithArray:[jsonDict valueForKey:@"items"]];
                    
                for(NSDictionary* results in videos) {
                        
                    NSString* tmp_id = [results valueForKey:@"id"];
                    NSString* tmp_title = [[results valueForKey:@"snippet"] valueForKey:@"title"];
                    NSString* tmp_date = [[results valueForKey:@"snippet"] valueForKey:@"publishedAt"];
                    NSString* tmp_description = [[results valueForKey:@"snippet"] valueForKey:@"description"];
                    NSString* tmp_thumbnails = [[[[results valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"medium"] valueForKey:@"url"];
                    
                    DataVideo* v = [[DataVideo alloc] initWithId:tmp_id title:tmp_title date:tmp_date description:tmp_description thumbnails:tmp_thumbnails];
                        
                    [video_list addObject:v];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }
            }
        }];
        
        [dataTask resume];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[];
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    favoriteViewController = [[FavoriteViewController alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"test will");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"test did");
    //[fVideoArray addObject:self.fVideo];
    //NSLog(@"data list: %@",fVideoArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResults.count;
    }else {
        return video_list.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        dataVideo = [video_list objectAtIndex:indexPath.row];
    }

    cell.titleCell.text = dataVideo.title_;
    cell.detailsCell.text = dataVideo.date_;
    NSURL* urlImage = [NSURL URLWithString: [[video_list objectAtIndex:indexPath.row] thumbnails_]];
    NSData* img = [[NSData alloc] initWithContentsOfURL: urlImage];
    cell.thumbnailCell.image = [UIImage imageWithData:img];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    videoViewController = [[VideoViewController alloc] init];
    DataVideo* data_ = [video_list objectAtIndex:indexPath.row];
    videoViewController.dataVideo = data_;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 330;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"update search");
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSLog(@"search for text");
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title_ contains[c] %@", searchText];
    NSLog(@"%@", [video_list filteredArrayUsingPredicate:predicate]);
    searchResults = [video_list filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"search bar");
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void) touchFavorite:(id)sender {
    NSLog(@"Favoris");
    //favoriteViewController = [[FavoriteViewController alloc] init];
    //VideoViewController* videoViewController = [[VideoViewController alloc] init];
    //fVideoArray_ = videoViewController.fVideo;
    NSLog(@"fvideoarray %@", self.fVideoArray);
    favoriteViewController.video_listF = self.fVideoArray;
    [self.navigationController pushViewController:favoriteViewController animated:YES];
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
