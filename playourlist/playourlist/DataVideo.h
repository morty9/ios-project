//
//  DataVideo.h
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataVideo : UIViewController {
 
    @private
    NSString* id_v;
    NSString* title_v;
    NSString* date_v;
    NSString* description_v;
    NSString* thumbnails_v;
    NSString* channels_v;
    NSMutableArray<NSString*>* tags_v;
    NSDate *addFavoriteDate_v;
}

@property (nonatomic, strong) NSString* id_;
@property (nonatomic, strong) NSString* title_;
@property (nonatomic, strong) NSString* date_;
@property (nonatomic, strong) NSString* description_;
@property (nonatomic, strong) NSString* thumbnails_;
@property (nonatomic, strong) NSString* channels_;
@property (nonatomic, strong) NSMutableArray<NSString*>* tags_;
@property (nonatomic, strong) NSDate *addFavoriteDate_;

/* Init */
- (instancetype) initWithId:(NSString*)id_video title:(NSString*)title_video date:(NSString*)date_video description:(NSString*)description_video thumbnails:(NSString*)thumbnails_video channels:(NSString*)channels_video tags:(NSMutableArray<NSString*>*)tags_video;

@end
