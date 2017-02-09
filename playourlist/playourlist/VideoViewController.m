//
//  VideoViewController.m
//  playourlist
//
//  Created by Bérangère La Touche on 03/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "VideoViewController.h"
#import "YTPlayerView.h"
#import "FavoriteViewController.h"
#import "ListViewController.h"


@interface VideoViewController ()
{
    FavoriteViewController* favoriteViewController;
    ListViewController* listViewController;
}

@end

@implementation VideoViewController

@synthesize videoView = _videoView;
@synthesize titleView = _titleView;
@synthesize detailsView = _detailsView;
@synthesize descriptionView = _descriptionView;
@synthesize dataVideo = dataVideo_;
@synthesize fVideo = fVideo_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        listViewController = [[ListViewController alloc] init];
        favoriteViewController = [[FavoriteViewController alloc] init];
        self.fVideo = [[NSMutableArray<DataVideo*> alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = self.dataVideo.title_;
    self.detailsView.text = self.dataVideo.date_;
    self.descriptionView.text = self.dataVideo.description_;
    [self.videoView loadWithVideoId:self.dataVideo.id_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchShare:(id)sender {
    
}

- (IBAction)touchFavorite:(id)sender {
    NSLog(@"favorite");
    [self.fVideo addObject:dataVideo_];
    NSLog(@"data %@",self.fVideo);
    [listViewController.fVideoArray addObject:self.dataVideo];
    NSLog(@"%@",listViewController.fVideoArray);
    //favoriteViewController.dataVideoF = self.dataVideo;
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
