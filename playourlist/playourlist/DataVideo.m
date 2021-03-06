//
//  DataVideo.m
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "DataVideo.h"

@interface DataVideo ()

@end

@implementation DataVideo

@synthesize id_ = id_v;
@synthesize title_ = title_v;
@synthesize date_ = date_v;
@synthesize description_ = description_v;
@synthesize thumbnails_ = thumbnails_v;
@synthesize channels_ = channels_v;
@synthesize tags_ = tags_v;
@synthesize addFavoriteDate_ = addFavoriteDate_v;

- (instancetype) initWithId:(NSString*)id_video title:(NSString*)title_video date:(NSString*)date_video description:(NSString*)description_video thumbnails:(NSString*)thumbnails_video channels:(NSString *)channels_video tags:(NSMutableArray<NSString*>*)tags_video {
    self = [super init];
    if(self != nil) {
        self.id_ = id_video;
        self.title_ = title_video;
        self.date_ = date_video;
        self.description_ = description_video;
        self.thumbnails_ = thumbnails_video;
        self.channels_ = channels_video;
        self.tags_ = tags_video;
        
        NSString* date = self.date_;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        NSDate* dte = [formatter dateFromString:date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
        self.date_ = [dateFormatter stringFromDate:dte];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
