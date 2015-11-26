//
//  YKSBuyCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/21.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSCloseButton.h"

@interface YKSBuyCell : UITableViewCell

@end


@interface YKSBuyAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@interface YKSBuyDrugCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *centerCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeFlagView;

@end

@interface YKSBuyLabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YKSCloseButton *leftButton;
@property (weak, nonatomic) IBOutlet YKSCloseButton *centerButton;
@property (weak, nonatomic) IBOutlet YKSCloseButton *rightButton;

@end


@interface YKSBuyCouponCell : UITableViewCell

@end
