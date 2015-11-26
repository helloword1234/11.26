//
//  YKSShoppingCartBuyVC.h
//  YueKangSong
//
//  Created by gongliang on 15/5/25.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSShoppingCartBuyVC : UIViewController

@property (nonatomic, strong) NSArray *drugs;

@property (nonatomic, assign) CGFloat totalPrice;
//传给ping的支付类型
@property(nonatomic,retain)NSString *channel;

-(void)showAlertWait;
-(void)showAlertMessage:(NSString *)msg;
-(void)hideAlert;

@end
