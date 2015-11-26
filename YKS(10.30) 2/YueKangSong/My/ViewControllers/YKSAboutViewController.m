//
//  YKSAboutViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSAboutViewController.h"
#import "YKSTools.h"

@interface YKSAboutViewController ()

@end

@implementation YKSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)phoneAction:(id)sender {
    [YKSTools call:kServerPhone inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
