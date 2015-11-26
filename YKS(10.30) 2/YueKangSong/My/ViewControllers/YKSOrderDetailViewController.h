//
//  YKSOrderDetailViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/29.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSConstants.h"

@interface YKSOrderDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *orderInfo;
@property (nonatomic, assign) YKSOrderStatus status;

@end
