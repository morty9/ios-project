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
    NSArray *arraySection;
    NSMutableArray *resultSection1;
    NSMutableArray *resultSection2;
    NSDate *addDate;
}

@end

@implementation FavoriteViewController

@synthesize dataVideoF = dataVideoF_;
@synthesize video_listF = video_listF_;
@synthesize addDate = addDate_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        
        vvc = [[VideoViewController alloc] init];
        
        arraySection = [[NSArray alloc] initWithObjects:@"Recently Added", @"More One Month", nil];
        resultSection1 = [[NSMutableArray alloc] init];
        resultSection2 = [[NSMutableArray alloc] init];
        addDate = [[NSDate alloc] init];
        
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

//    NSDateComponents *dateComponents = [NSDateComponents new];
//    //dateComponents.month = -1;
//    dateComponents.minute = -1;
//    NSDate* month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self.addDate options:0];
//    NSLog(@"last month %@",month);
//    
//    for (DataVideo* r in self.video_listF) {
//        if(r.addFavoriteDate_ > month) {
//            NSLog(@"test");
//            [resultSection1 addObject:r];
//        }else {
//            NSLog(@"test2");
//            [resultSection2 addObject:r];
//        }
//    }
//    
//    NSLog(@"section 1 %@",resultSection1);
//    NSLog(@"section 2 %@",resultSection2);
    //resultSection = [[arraySection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    BOOL checkArray = false;
    NSDateComponents *dateComponents = [NSDateComponents new];
    //dateComponents.month = -1;
    dateComponents.minute = -1;
    NSDate *d = [NSDate date];
    NSDate* month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:d options:0];
    resultSection1 = [[NSMutableArray alloc] init];
    resultSection2 = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArray1 = [resultSection1 mutableCopy];
    NSMutableArray *tmpArray2 = [resultSection2 mutableCopy];
    NSLog(@"tmp 1 %@", tmpArray1);
    NSLog(@"tmp 2 %@", tmpArray2);
    
    for (DataVideo* r in self.video_listF) {
        if([r.addFavoriteDate_ compare:month] == NSOrderedDescending) {
            NSLog(@"test");
            if(resultSection1.count != 0) {
                for (DataVideo* check in resultSection1) {
                    if(r == check) {
                        [tmpArray2 addObject:check];
                        [tmpArray1 removeObject:check];
                        checkArray = true;
                    }
                }
                if(checkArray == false) {
                    [tmpArray1 addObject:r];
                }else {
                    resultSection2 = tmpArray2;
                }
            }else {
                [tmpArray1 addObject:r];
            }
            resultSection1 = tmpArray1;
        }else {
            NSLog(@"test2");
            if(resultSection2.count != 0) {
                for (DataVideo* check in resultSection2) {
                    if(r == check) {
                        //[tmpArray2 removeObject:check];
                        checkArray = true;
                    }
                }
                if(checkArray == false) {
                    [tmpArray2 addObject:r];
                }else {
                    resultSection2 = tmpArray2;
                }
            }else {
                [tmpArray2 addObject:r];
            }
            resultSection2 = tmpArray2;
        }
    }
    
    NSLog(@"section 1 %@",resultSection1);
    NSLog(@"section 2 %@",resultSection2);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchEdit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [arraySection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arraySection objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return searchResults.count;
    }else {
        if(section == 0) {
            return resultSection1.count;
        }else if (section == 1){
            return resultSection2.count;
        }
        //return video_listF_.count;
    }
    
    return 1;
//    NSString *sectionTitle = [arraySection objectAtIndex:section];
//    NSArray *sectionAnimals = [resultSection1 objectForKey:sectionTitle];
//    return [sectionAnimals count];
    
   // return [sectionAnimals count];
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
        if(indexPath.section == 0) {
            dataVideo = [resultSection1 objectAtIndex:indexPath.row];
        }else if(indexPath.section == 1) {
            dataVideo = [resultSection2 objectAtIndex:indexPath.row];
        }
        //dataVideo = [video_listF_ objectAtIndex:indexPath.row];
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
