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

@interface ListViewController ()
{
    NSMutableArray<DataVideo*> *video_list ;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    video_list = [[NSMutableArray<DataVideo*> alloc] init];
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    NSString *urlString = [NSString stringWithFormat:@"%@&key=%@", @"https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular", APIKey];
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
                NSURL* tmp_thumbnails = [[[results valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"url"];
                
                
                DataVideo* v = [[DataVideo alloc] initWithId:tmp_id title:tmp_title date:tmp_date description:tmp_description thumbnails:tmp_thumbnails];
                
                //NSLog(@"%@", v.title_);
                [video_list addObject:v];
                
            }
            
            /*for(DataVideo* r in video_list) {
                NSLog(@"item : %@", [r title_]);
            }*/
            
        }
        
    }];
    
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
