//
//  YKSCityViewController.h
//  YueKangSong
//
//  Created by 范 on 15/9/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSCityViewController : UIViewController



@property(nonatomic,copy) void(^myBlock)(NSString *cityName);

-(instancetype)initWithBlock:(void(^)(NSString *cityName))a;
@end
