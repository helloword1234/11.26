//
//  AppDelegate.h
//  YueKangSong
//
//  Created by gongliang on 15/5/12.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//运费价格配置
@property (strong, nonatomic) NSDictionary *baseInfo;

+ (YKSAppDelegate *)sharedAppDelegate;

@end

