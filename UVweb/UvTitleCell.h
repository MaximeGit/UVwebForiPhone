//
//  UvTitleCell.h
//  UVweb
//
//  Created by Maxime on 18/03/2014.
//  Copyright (c) 2014 UVweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Uv.h"

@interface UvTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *uvTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uvInfoLabel;

- (void) configureCellWithUv:(Uv*)uv;

@end
