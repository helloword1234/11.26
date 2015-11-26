//
//  YKSSearchStreetVC.h
//  YueKangSong
//
//  Created by gongliang on 15/7/22.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSSearchStreetVC : UIViewController

@property (nonatomic, strong) void(^callback)(NSDictionary *street);

@property(nonatomic,copy)NSString *streetName;

@property(nonatomic,copy) NSString *cityName;

@end
