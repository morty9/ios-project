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

@interface VideoViewController ()
{
    NSMutableArray<DataVideo*>* video_f;
    FavoriteViewController* favoriteViewController;
}

@end

@implementation VideoViewController

@synthesize videoView = _videoView;
@synthesize titleView = _titleView;
@synthesize detailsView = _detailsView;
@synthesize descriptionView = _descriptionView;

@synthesize idVideo = idVideo_;
@synthesize titleVideo = titleVideo_;
@synthesize detailsVideo = detailsVideo_;
@synthesize descriptionVideo = descriptionVideo_;
@synthesize dataVideo = dataVideo_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        favoriteViewController = [[FavoriteViewController alloc] init];
        video_f = [[NSMutableArray<DataVideo*> alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = self.dataVideo.title_;
    self.detailsView.text = self.dataVideo.date_;
    self.descriptionView.text = self.dataVideo.description_;
    [self.videoView loadWithVideoId:self.dataVideo.id_];
    
    //self.titleView.text = self.titleVideo;
    //self.detailsView.text = self.detailsVideo;
    //self.descriptionView.text = self.descriptionVideo;
    //[self.videoView loadWithVideoId: self.idVideo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchShare:(id)sender {
    
}

- (IBAction)touchFavorite:(id)sender {
    NSLog(@"favorite");
    //[video_f addObject:dataVideo_];
    NSLog(@"data %@",dataVideo_);
    favoriteViewController.dataVideoF = self.dataVideo;
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
