//
//  YKSFeedbackViewController.m
//  YueKangSong
//
//  Created by gongliang on 15/6/1.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSFeedbackViewController.h"
#import "GZBaseRequest.h"
 
@interface YKSFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation YKSFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_textView becomeFirstResponder];
}

- (IBAction)submitFeedback:(id)sender {
    if (IS_EMPTY_STRING(_textView.text)) {
        [self showToastMessage:@"请填写内容"];
        return;
    }
    [GZBaseRequest feedbackByContent:_textView.text
                            callback:^(id responseObject, NSError *error) {
                                if (error) {
                                    [self showToastMessage:@"网络加载失败"];
                                    return ;
                                }
                                if (ServerSuccess(responseObject)) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    [self.navigationController showToastMessage:@"反馈成功，谢谢"];
                                } else {
                                    [self showToastMessage:responseObject[@"msg"]];
                                }
        
    }];
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
