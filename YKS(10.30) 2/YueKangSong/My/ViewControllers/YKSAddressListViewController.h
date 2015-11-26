//
//  YKSAddressListViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSAddressListViewController : UIViewController

@property (nonatomic, strong) void(^callback)(NSDictionary *addressInfo);

@end
