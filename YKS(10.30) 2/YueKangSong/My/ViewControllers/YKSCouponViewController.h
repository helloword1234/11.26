//
//  YKSCouponViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^ReturnCouponBlock)(NSMutableArray *couponArray);

@interface YKSCouponViewController : UIViewController

@property (nonatomic, assign) CGFloat totalPirce;
@property (nonatomic, strong) void(^callback)(NSDictionary *couponInfo);

//@property (nonatomic, copy) ReturnCouponBlock returnCouponBlock;
//
//- (void)returnText:(ReturnCouponBlock)block;
//
@end
