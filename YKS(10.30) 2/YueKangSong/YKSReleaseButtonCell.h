//
//  YKSReleaseButton.h
//  YKSPharmacistRecommend
//
//  Created by TT on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 表头View
 */

@protocol YKSReleaseButtonCellDelegate <NSObject>
- (void)clickButton:(UIButton *)button;
@end

@interface YKSReleaseButtonCell : UITableViewCell
@property (nonatomic,strong) UIButton *clickButton;
//显示按钮图标
@property (nonatomic,strong) UIImageView *selectedImage;
//显示总价
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong)id <YKSReleaseButtonCellDelegate> delegate;
@property (nonatomic,assign)CGFloat totalPrice;
- (instancetype)initWithPrice:(float)price andSection:(NSString *)section andFrame:(CGRect)frame;
@end
