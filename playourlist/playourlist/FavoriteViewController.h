//
//  FavoriteViewController.h
//  playourlist
//
//  Created by Bérangère La Touche on 08/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"

@interface FavoriteViewController : UIViewController {
    
    @private
    NSMutableArray* video_listF_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* video_listF;
@property (strong, nonatomic) UISearchController *searchController;

/* Init */
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

/* Sort data and put videos in the good section */
- (void)viewDidAppear:(BOOL)animated;

/* Edit list */
- (void) touchEdit:(id)sender;

/* Update table view with search result */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;

/* Get videos with the same title research */
- (void)searchForText:(NSString*)searchText;

@end
