//
//  ListViewController.h
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"

@interface ListViewController : UIViewController {
    NSMutableArray<DataVideo*>* fVideoArray_;
    NSDate *currentDate_;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<DataVideo*>* fVideoArray;
@property (nonatomic, strong) NSDate *currentDate;

- (void) tagsSort:(NSMutableDictionary*)tagsVideo dataVideos:(NSMutableArray<DataVideo*>*)data resultsTags:(NSMutableArray<NSString*>*)results;

- (void)atTags:(NSString*)tags allTags:(NSMutableDictionary*)tagsVideo;

@end
