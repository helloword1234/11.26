//
//  YKSDrugListCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YKSDrug.h"

@interface YKSDrugListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sellOverIV;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeFlagView;

@property (strong, nonatomic) NSDictionary *drugInfo;

@end
