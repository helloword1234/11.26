//
//  UIViewController+Common.h
//  GZTour
//
//  Created by gongliang on 14/12/5.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Common)

- (void)showProgress;

- (void)hideProgress;

- (void)showToastMessage:(NSString *)message;

- (void)showToastMessage:(NSString *)message time:(CGFloat)time;

- (void)showAlertTitle:(NSString *)title message:(NSString *)message;

@end
