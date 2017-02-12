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

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, VideoViewControllerDelegate>
{
    NSMutableArray<DataVideo*> *video_list ;
    NSMutableDictionary *video_l;
    NSArray *searchResults;
    NSArray *sectionVideo;
    NSMutableDictionary* tagsVideos;
    NSMutableArray<NSString*>* resultsTags;
    FavoriteViewController* favoriteViewController;
    VideoViewController* videoViewController;
}
@end

@implementation ListViewController

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
        video_l = [[NSMutableDictionary alloc] init];
        sectionVideo = [[NSArray alloc] init];
        tagsVideos = [[NSMutableDictionary alloc] init];
        resultsTags = [[NSMutableArray<NSString*> alloc] initWithCapacity:10];
        fVideoArray_ = [[NSMutableArray<DataVideo*> alloc] init];
        favoriteViewController = [[FavoriteViewController alloc] init];
        
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
                    NSString* tmp_channels = [[results valueForKey:@"snippet"] valueForKey:@"channelTitle"];
                    NSArray<NSString*>* tmp_tags = [[results valueForKey:@"snippet"] valueForKey:@"tags"];
                    
                    DataVideo* v = [[DataVideo alloc] initWithId:tmp_id title:tmp_title date:tmp_date description:tmp_description thumbnails:tmp_thumbnails channels:tmp_channels tags:tmp_tags];
                    
                    //NSLog(@"tags %@", v.tags_);
                        
                    [video_list addObject:v];
                    //[video_l setValue:v forKey:v.channels_];
                    
                    //NSLog(@"key %@", video_l);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }
                [self tagsSort:tagsVideos dataVideos:video_list resultsTags:resultsTags];
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
    
    //sectionVideo = [[video_l allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return [sectionVideo count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [sectionVideo objectAtIndex:section];
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResults.count;
    }else {
        return video_list.count;
    }
    
    //NSString *sectionTitle = [sectionVideo objectAtIndex:section];
    //NSArray *sectionVideos = [video_l objectForKey:sectionTitle];
    //return [sectionVideos count];
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
    
//    NSString *sectionTitle = [sectionVideo objectAtIndex:indexPath.section];
//    NSArray *sectionVideos = [video_l objectForKey:sectionTitle];
//    NSString *animal = [sectionVideos objectAtIndex:indexPath.row];
//    cell.textLabel.text = animal;
    //cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];

    cell.titleCell.text = dataVideo.title_;
    cell.detailsCell.text = dataVideo.date_;
    NSURL* urlImage = [NSURL URLWithString: dataVideo.thumbnails_];
    NSData* img = [[NSData alloc] initWithContentsOfURL: urlImage];
    cell.thumbnailCell.image = [UIImage imageWithData:img];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 4.0f;
    
    return cell;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    videoViewController = [[VideoViewController alloc] init];
    DataVideo* data_ = nil;
    if(self.searchController.isActive) {
        data_ = [searchResults objectAtIndex:indexPath.row];
    }else {
        data_ = [video_list objectAtIndex:indexPath.row];
    }
    videoViewController.dataVideo = data_;
    videoViewController.delegate = self;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 330;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString*)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title_ contains[c] %@", searchText];
    //NSLog(@"%@", [video_list filteredArrayUsingPredicate:predicate]);
    searchResults = [video_list filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)touchFavorite:(id)sender {
    favoriteViewController.video_listF = fVideoArray_;
    [favoriteViewController.tableView reloadData];
    [self.navigationController pushViewController:favoriteViewController animated:YES];
}

- (void)VideoViewController:(VideoViewController*)videoViewController didAddValue:(DataVideo*)value {
    
    if(value != nil) {
        [self.fVideoArray addObject:value];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tagsSort:(NSMutableDictionary*)tagsVideo_ dataVideos:(NSMutableArray<DataVideo*>*)data resultsTags:(NSMutableArray<NSString *> *)results {
    
    for (DataVideo* v in data) {
        for(NSString* tags in v.tags_) {
            [self atTags:tags allTags:tagsVideo_];
        }
    }
    
    [self bestOfTags:resultsTags tagsVideos:tagsVideos];
    
    NSLog(@"tags final %@", tagsVideo_);
}

- (void)atTags:(NSString*)tags allTags:(NSMutableDictionary*)tagsVideo {
    
    NSNumber* counterTags = [[NSNumber alloc] initWithInt:1];
    BOOL isAdd = false;
    
    if(tagsVideo.count == 0) {
        [tagsVideo setObject:counterTags forKey:tags];
        isAdd = true;
    }else {
        
        for (NSString* tag in tagsVideo) {
            if(tags == tag) {
                NSNumber* tmp = [tagsVideo objectForKey:tags];
                int count = [tmp intValue];
                tmp = [NSNumber numberWithInt:count+1];
                [tagsVideo setObject:tmp forKey:tags];
                isAdd = true;
                break;
            }
        }
        if(isAdd == false) {
            [tagsVideo setObject:counterTags forKey:tags];
        }
    }
}

- (void)bestOfTags:(NSMutableArray<NSString*>*)bestOfTags tagsVideos:(NSMutableDictionary*)allTags {
    
    NSString* highIncrement = [[NSString alloc] initWithString:[[allTags allKeys] objectAtIndex:0]];
    
    for(NSString* stringTags in allTags) {
        if(stringTags != highIncrement) {
            if([allTags valueForKey:stringTags] > [allTags valueForKey:highIncrement]) {
                highIncrement = stringTags;
                [bestOfTags addObject:highIncrement];
            }
        }
    }
    //[bestOfTags addObject:highIncrement];
    NSLog(@"best tags %@",bestOfTags);
    
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
