//
//  YKSWebViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSWebViewController.h"

@interface YKSWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YKSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"悦康送";
    // Do any additional setup after loading the view.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webURLString]];
    [_webView loadRequest:request];
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
