//
//  FavoriteViewController.h
//  playourlist
//
//  Created by Bérangère La Touche on 08/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"

@interface FavoriteViewController : UIViewController {
    
    @private
    DataVideo* dataVideoF_;
    NSMutableArray<DataVideo*>* video_listF_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) DataVideo* dataVideoF;
@property (nonatomic, strong) NSMutableArray<DataVideo*>* video_listF;
@property (strong, nonatomic) UISearchController *searchController;

@end
