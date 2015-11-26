//
//  YKSDrugShuoMingViewController.m
//  YueKangSong
//
//  Created by 范 on 15/9/9.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSDrugShuoMingViewController.h"

@interface YKSDrugShuoMingViewController ()<UITextViewDelegate>
@property (strong, nonatomic)  UITextView *shuoMingText;

@end

@implementation YKSDrugShuoMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shuoMingText=[[UITextView alloc]initWithFrame:self.view.frame];
   
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame=_shuoMingText.frame;
    
    
    
    [_shuoMingText addSubview:btn];
    
    [self.view addSubview:_shuoMingText];
    
    self.shuoMingText.text = _shuoMingDic[@"gmanual"];
   _shuoMingText.layoutManager.allowsNonContiguousLayout = NO;
    _shuoMingText.showsVerticalScrollIndicator=NO;
    _shuoMingText.bounces=NO;
    
}

#pragma mark UITextView  代理方法



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
