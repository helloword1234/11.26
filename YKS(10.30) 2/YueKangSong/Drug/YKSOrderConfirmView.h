//
//  YKSOrderConfirmView.h
//  YueKangSong
//
//  Created by gongliang on 15/5/24.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSOrderConfirmView : UIView

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

+ (void)showOrderToView:(UIView *)view
                orderId:(NSString *)orderId
               callback:(void(^)())callback;

@end
