//
//  UIViewController+Common.m
//  GZTour
//
//  Created by gongliang on 14/12/5.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "UIViewController+Common.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "YKSTools.h"

@implementation UIViewController (Common)

- (void)showProgress
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideProgress
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showToastMessage:(NSString *)message time:(CGFloat)time {
    if (IS_EMPTY_STRING(message)) {
        return ;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:time];
}

- (void)showToastMessage:(NSString *)message {
    if (IS_EMPTY_STRING(message)) {
        return ;
    }
    [YKSTools showToastMessage:message inView:self.view];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if([version compare:@"8.0"] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                       
                                                         }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


@end
