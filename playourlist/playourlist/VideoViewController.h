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
    DataVideo* dataVideo_;
    NSMutableArray<DataVideo*>* fVideo_;
}

@property (weak, nonatomic) IBOutlet YTPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailsView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (nonatomic, strong) DataVideo* dataVideo;
@property (nonatomic, strong) NSMutableArray<DataVideo*>* fVideo;

@end
