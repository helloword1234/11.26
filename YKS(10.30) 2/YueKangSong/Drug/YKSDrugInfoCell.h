//
//  YKSDrugInfoCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/16.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSDrugInfoCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *drugInfo;

@end


@interface YKSDrugNameCell : YKSDrugInfoCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidthLayout;

@end


@interface YKSDrugActionCell : YKSDrugInfoCell
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;

@end


@interface YKSDrugDescribeCell : YKSDrugInfoCell
@property (weak, nonatomic) IBOutlet UILabel *factoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (weak, nonatomic) IBOutlet UILabel *drugStoreNameLable;

@end
