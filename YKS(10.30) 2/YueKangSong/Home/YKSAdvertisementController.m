//
//  YKSAdvertisementController.m
//  YueKangSong
//
//  Created by Saintly on 15/11/10.
//  Copyright © 2015年 YKS. All rights reserved.
//

#import "YKSAdvertisementController.h"

@interface YKSAdvertisementController ()
//广告视图
@property(nonatomic,strong) UIImageView *AdvertisementImage;
//跳过按钮
@property (nonatomic,strong) UIButton *JumpButton;
//广告展示时间
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *timer1;

@property (nonatomic,strong) NSData *resultData;
@end

@implementation YKSAdvertisementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSString *str = @"http://api.yuekangsong.com/activity/index?op_type=indexpage";
    NSURL *urlStr = [NSURL URLWithString:str];
    self.resultData = [NSData dataWithContentsOfURL:urlStr];
    if (self.resultData != nil) {
        [self displayRecommendation];
        
    }else{
        self.timer1 = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSDefaultRunLoopMode];
    }
    
}




- (void)displayRecommendation
{
    self.AdvertisementImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCRENN_HEIGHT)];
    self.AdvertisementImage.image = [UIImage imageWithData:self.resultData];
    
    self.JumpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.JumpButton.frame = CGRectMake(self.view.bounds.size.width - 60, 30, 30, 25);
    [self.JumpButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.JumpButton addTarget:self action:@selector(removeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.JumpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.AdvertisementImage];
    [self.view addSubview:self.JumpButton];
    self.timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(removeImage) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)removeImage
{
    [self.timer invalidate];
    [self.JumpButton removeFromSuperview];
    [self.AdvertisementImage removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadInputViews];
}

- (void)dismiss
{
    [self.timer1 invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
