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

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate>
{
    NSMutableArray<DataVideo*> *video_list ;
    NSMutableArray *searchResults;
    NSArray* finalResults;
}
@end

@implementation ListViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        NSLog(@"init");
        video_list = [[NSMutableArray<DataVideo*> alloc] init];
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        dataVideo = [searchResults objectAtIndex:indexPath.row];
    } else {
        dataVideo = [video_list objectAtIndex:indexPath.row];
    }
    
    
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    //cell.titleCell.text = [[video_list objectAtIndex:indexPath.row] title_];
    cell.titleCell.text = dataVideo.title_;
    //cell.detailsCell.text = [[video_list objectAtIndex:indexPath.row] date_];
    cell.detailsCell.text = dataVideo.date_;
    NSURL* urlImage = [NSURL URLWithString: [[video_list objectAtIndex:indexPath.row] thumbnails_]];
    NSData* img = [[NSData alloc] initWithContentsOfURL: urlImage];
    cell.thumbnailCell.image = [UIImage imageWithData:img];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* idV = [[video_list objectAtIndex:indexPath.row] id_];
    NSString* title = [[video_list objectAtIndex:indexPath.row] title_];
    NSString* details = [[video_list objectAtIndex:indexPath.row] date_];
    NSString* description = [[video_list objectAtIndex:indexPath.row] description_];
    VideoViewController* videoViewController = [[VideoViewController alloc] init];
    videoViewController.idVideo = idV;
    videoViewController.titleVideo = title;
    videoViewController.detailsVideo = details;
    videoViewController.descriptionVideo = description;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
}


-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"should reload");
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    searchResults = [NSMutableArray new];
    for(DataVideo* r in video_list) {
        [searchResults addObject:[r title_]];
    }
    //NSLog(@"source: %@", searchResults );
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    NSLog(@"predicate %@",resultPredicate);
    //searchResults = [[video_list]filteredArrayUsingPredicate:resultPredicate];
    //finalResults = [searchResults filteredArrayUsingPredicate:resultPredicate];
    finalResults = searchResults;
    //NSLog(@"results %@",[searchResults filteredArrayUsingPredicate:resultPredicate]);
    NSLog(@"results %@",[searchResults filteredArrayUsingPredicate:resultPredicate]);
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
