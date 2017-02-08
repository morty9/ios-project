//
//  VideoViewController.h
//  playourlist
//
//  Created by Bérangère La Touche on 03/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "DataVideo.h"

@interface VideoViewController : UIViewController {
    
    @private
    NSString* idVideo_;
    NSString* titleVideo_;
    NSString* detailsVideo_;
    NSString* descriptionVideo_;
    
    DataVideo* dataVideo_;
}

@property (weak, nonatomic) IBOutlet YTPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailsView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) NSString* idVideo;
@property (nonatomic,strong) NSString* titleVideo;
@property (nonatomic,strong) NSString* detailsVideo;
@property (nonatomic,strong) NSString* descriptionVideo;
@property (nonatomic, strong) DataVideo* dataVideo;

@end
