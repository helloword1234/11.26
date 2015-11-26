//
//  YKSShoppingCartBuyCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/25.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSShoppingCartBuyCell : UITableViewCell

@end


@interface YKSShoppingBuyDrugCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeFlagView;

@end


@interface YKSShoppingBuyTotalInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
