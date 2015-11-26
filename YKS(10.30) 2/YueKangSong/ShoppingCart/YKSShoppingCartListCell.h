//
//  YKSShoppingCartListCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/19.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKSShoppingCartListCell;

typedef void(^countCallback)(NSInteger count, YKSShoppingCartListCell *cell);

@interface YKSShoppingCartListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *priceSuperView;
@property (weak, nonatomic) IBOutlet UIView *addSuperView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerCountLabel;

@property (strong, nonatomic) NSMutableDictionary *drugInfo;
//这个表示那个购物车中,哪个药品被选择,参与计算价格
//一看,这是一个输出口,看来这个是被别人决定的,我们走到信息的头部
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (strong, nonatomic) void(^countCallback)(NSInteger count, YKSShoppingCartListCell *cell);
@property (weak, nonatomic) IBOutlet UIImageView *recipeFlagView;

@property (nonatomic, copy)countCallback priceBlock;

-(void)estimatePriceAndUpdateUI:(countCallback)priceBlock;

@end
