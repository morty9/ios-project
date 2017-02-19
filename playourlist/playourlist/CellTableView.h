//
//  CellTableView.h
//  playourlist
//
//  Created by Bérangère La Touche on 03/02/2017.
//  Copyright © 2017 Bérangère La Touche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataVideo.h"

@interface CellTableView : UITableViewCell {
    DataVideo* data_;
}
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailCell;
@property (weak, nonatomic) IBOutlet UILabel *titleCell;
@property (weak, nonatomic) IBOutlet UILabel *detailsCell;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) DataVideo *data;

@end
