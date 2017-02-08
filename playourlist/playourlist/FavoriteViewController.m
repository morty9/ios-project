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

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FavoriteViewController

@synthesize dataVideoF = dataVideoF_;
@synthesize video_listF = video_listF_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        NSLog(@"init favorite");
        //dataVideoF_ = [[DataVideo alloc] init];
        NSLog(@"dataVideo %@", self.dataVideoF);
        //video_listF_ = [[NSMutableArray<DataVideo*> alloc] init];
        [self.video_listF addObject:self.dataVideoF];
        NSLog(@"data:%@", self.video_listF);
        /*dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });*/
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return video_listF_.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellId = @"CellTableView";
    
    CellTableView* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellTableView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DataVideo* dataVideo = nil;
    //if(self.searchController.isActive) {
    //    dataVideo = [searchResults objectAtIndex:indexPath.row];
    //}else {
    dataVideo = [video_listF_ objectAtIndex:indexPath.row];
    //}
    
    
    //cell.layer.borderWidth = 2.0;
    //cell.layer.borderColor = [UIColor grayColor].CGColor;
    //cell.titleCell.text = [[video_list objectAtIndex:indexPath.row] title_];
    cell.titleCell.text = dataVideo.title_;
    //cell.detailsCell.text = [[video_list objectAtIndex:indexPath.row] date_];
    cell.detailsCell.text = dataVideo.date_;
    NSURL* urlImage = [NSURL URLWithString: [[video_listF_ objectAtIndex:indexPath.row] thumbnails_]];
    NSData* img = [[NSData alloc] initWithContentsOfURL: urlImage];
    cell.thumbnailCell.image = [UIImage imageWithData:img];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoViewController* videoViewController = [[VideoViewController alloc] init];
    DataVideo* data_ = [video_listF_ objectAtIndex:indexPath.row];
    videoViewController.dataVideo = data_;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 330;
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
