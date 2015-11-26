////
////  YKSOneBuyCell.h
////  YKSPharmacistRecommend
////
////  Created by ydz on 15/10/23.
////  Copyright © 2015年 ydz. All rights reserved.
////
//
#import <UIKit/UIKit.h>
/*
    设置展开方案药品最下方的"一键加入购物车"View
 */
@interface YKSOneBuyCell : UIView
//公开方法 创建同时赋值过来
- (instancetype)initWithPrice:(float)price andViewFrame:(CGRect)frame andButton:(UIButton *)button;

@end
