//
//  ListViewController.m
//  playourlist
//
//  Created by Bérangère La Touche on 31/01/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "ListViewController.h"
#import "APIKey.h"
#import "DataVideo.h"

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray<DataVideo*> *video_list ;
}
@end

@implementation ListViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self != nil) {
        NSLog(@"init");
        video_list = [[NSMutableArray<DataVideo*> alloc] init];
    
        NSURLSession* urlSession = [NSURLSession sharedSession];
        NSString *urlString = [NSString stringWithFormat: @"https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&key=%@", APIKey];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                
            if(!error) {
                NSError* error = nil;
                NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
                NSMutableArray* videos = [NSMutableArray arrayWithArray:[jsonDict valueForKey:@"items"]];
                    
                for(NSDictionary* results in videos) {
                        
                    NSString* tmp_id = [results valueForKey:@"id"];
                    NSString* tmp_title = [[results valueForKey:@"snippet"] valueForKey:@"title"];
                    NSString* tmp_date = [[results valueForKey:@"snippet"] valueForKey:@"publishedAt"];
                    NSString* tmp_description = [[results valueForKey:@"snippet"] valueForKey:@"description"];
                    NSURL* tmp_thumbnails = [[[[results valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"medium"] valueForKey:@"url"];
                    
                    DataVideo* v = [[DataVideo alloc] initWithId:tmp_id title:tmp_title date:tmp_date description:tmp_description thumbnails:tmp_thumbnails];
                        
                    [video_list addObject:v];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }
            }
        }];
        
        [dataTask resume];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return video_list.count;
}

static NSString* const kCellId = @"AZERTYUIOPQSDFGHJKL";

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    
    cell.textLabel.text = [[video_list objectAtIndex:indexPath.row] title_];
    //NSLog(@"%@",[[video_list objectAtIndex:indexPath.row] thumbnails_]);
    //NSData * imageData = [[NSData alloc] initWithContentsOfURL: ];
    //NSData* img = [[NSData alloc] initWithContentsOfURL: [[video_list objectAtIndex:indexPath.row] thumbnails_ ]];
    //UIImage* image = [UIImage imageWithData:img];
    //cell.imageView.image = [UIImage imageWithData: img];
    
    return cell;
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
