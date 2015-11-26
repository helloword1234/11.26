//
//  YKSRegionViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSRegionViewController.h"
#import "GZBaseRequest.h"
#import "YKSConstants.h"

@interface YKSRegionViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation YKSRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textView.editable = NO;
    [GZBaseRequest baseInfocallback:^(id responseObject, NSError *error) {
        if (error) {
            [self showToastMessage:@"网络加载失败"];
            return ;
        }
        if (ServerSuccess(responseObject)) {
            NSDictionary *dic = responseObject[@"data"];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"distribution_imgurl"]]
                          placeholderImage:[UIImage imageNamed:@"icon"]];
            _textView.text = dic[@"distribution_dec"];
        } else {
            [self showToastMessage:responseObject[@"msg"]];
        }
        
    }];
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
