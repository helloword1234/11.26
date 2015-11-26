//
//  YKSMyHealthViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/6/10.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YKSHealthType) {
    YKSHealthTypeBlood = 0, //血型
    YKSHealthTypeStep = 1, //步数
    YKSHealthTypeWalkRunning = 2, //距离
    YKSHealthTypeRespiratoryRate = 3, //呼吸速率
    YKSHealthTypeBodyTemperature = 4, //体温
    YKSHealthTypeHeartRate = 5, //心率
    YKSHealthTypeBloodPressure = 6 //血压
    
};

@interface YKSMyHealthViewController : UIViewController

@property (assign, nonatomic) YKSHealthType healthType;

@end
