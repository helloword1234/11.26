//
//  YKSAddAddressVC.h
//  YueKangSong
//
//  Created by gongliang on 15/5/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YKSAddAddressVC : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *addressInfo;
@property (nonatomic, assign) BOOL isCurrentLocation;
@property (nonatomic, strong) void(^callback)();

@property(nonatomic,copy)NSString *cityName;

@property(nonatomic,copy)NSDictionary *streetDictionary;

@property(nonatomic,copy)NSString *flag;

@end
