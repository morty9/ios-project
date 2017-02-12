//
//  VideoViewController.m
//  playourlist
//
//  Created by Bérangère La Touche on 03/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "VideoViewController.h"
#import "YTPlayerView.h"

@interface VideoViewController ()
{
    NSArray *sharingData;
}
@end

@implementation VideoViewController

@synthesize videoView = _videoView;
@synthesize titleView = _titleView;
@synthesize detailsView = _detailsView;
@synthesize descriptionView = _descriptionView;
@synthesize dataVideo = dataVideo_;
@synthesize delegate = delegate_;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleView.text = self.dataVideo.title_;
    self.detailsView.text = self.dataVideo.date_;
    self.descriptionView.text = self.dataVideo.description_;
    [self.videoView loadWithVideoId:self.dataVideo.id_];
    
    NSString *urlString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",self.dataVideo.id_];
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    sharingData = [[NSArray alloc] initWithObjects:url, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchShare:(id)sender {
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems: sharingData  applicationActivities:nil];
    shareController.excludedActivityTypes = @[];
    [self presentViewController:shareController animated:YES completion:nil];
    
}

- (IBAction)touchFavorite:(id)sender {
    [self.delegate VideoViewController:self didAddValue:dataVideo_];
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
