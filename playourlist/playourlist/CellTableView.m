//
//  CellTableView.m
//  playourlist
//
//  Created by Bérangère La Touche on 03/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import "CellTableView.h"
#import "VideoViewController.h"

@interface CellTableView ()
{
    NSArray *sharingData;
}

@end

@implementation CellTableView

@synthesize thumbnailCell = _thumbnailCell;
@synthesize titleCell = _titleCell;
@synthesize detailsCell = _detailsCell;
@synthesize data = data_;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)touchShare:(id)sender {
}

- (IBAction)touchFavorite:(id)sender {
}


@end
