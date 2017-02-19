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

@class VideoViewController;

@protocol VideoViewControllerDelegate <NSObject>
@optional

- (void) VideoViewController:(VideoViewController*)videoViewController didAddValue:(DataVideo*)value;

@end

@interface VideoViewController : UIViewController {
    
    @private
    DataVideo* dataVideo_;
    __weak id<VideoViewControllerDelegate> delegate_;
}

@property (weak, nonatomic) IBOutlet YTPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailsView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (nonatomic, strong) DataVideo* dataVideo;
@property (nonatomic, weak) id<VideoViewControllerDelegate> delegate;

- (IBAction)touchShare:(id)sender;

@end
