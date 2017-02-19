//
//  ListViewController.h
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"

@interface ListViewController : UIViewController {
    NSMutableArray<DataVideo*>* fVideoArray_;
    NSDate *currentDate_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<DataVideo*>* fVideoArray;
@property (nonatomic, strong) NSDate *currentDate;

/* Get all data tags and create a dictionary from it */
- (void)tagsSort:(NSMutableDictionary*)tagsVideo dataVideos:(NSMutableArray<DataVideo*>*)data resultsTags:(NSMutableArray<NSString*>*)results;

/* Sort all videos with common tags */
- (void)atTags:(NSString*)tags allTags:(NSMutableDictionary*)tagsVideo;

/* Create the sections of the dictionary with most popular tags */
- (void)createSectionDictionary:(NSMutableArray<NSString*>*)bot data:(NSMutableArray<DataVideo*>*)videos;

/* Get most popular tags */
- (void)bestOfTags:(NSMutableArray<NSString*>*)bestOfTags tagsVideos:(NSMutableDictionary*)allTags;

/* Format strings */
- (NSString*)formattingString:(NSString*)string;

/* Add selected video to favorite list */
- (void)favoriteButton:(id)sender;

/* Button which allows to access to the favorite list */
- (void)touchFavorite:(id)sender;

/* Get videos with the same title research */
- (void)searchForText:(NSString*)searchText;

/* Update table view with search result */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;

/* Return cells data where the favorite button is clicked on */
- (DataVideo*) tableView:(UITableView *)tableView didSelect:(NSIndexPath *)indexPath;

/* Allows to share selected video */
- (void)shareButton:(id)sender;

/* Init */
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
