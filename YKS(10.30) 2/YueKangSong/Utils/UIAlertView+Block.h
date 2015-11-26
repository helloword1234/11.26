//
//  UIAlertView+Block.h
//  GZTour
//
//  Created by gongliang on 14/12/23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAlertView (Block) <UIAlertViewDelegate>

- (void)callBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block;

@end
