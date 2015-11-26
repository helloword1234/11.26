//
//  UIAlertView+Block.m
//  GZTour
//
//  Created by gongliang on 14/12/23.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static const void *GZUIAlertViewBlockKey = &GZUIAlertViewBlockKey;

@implementation UIAlertView (Block)

- (void)callBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))block {
    self.delegate = self;
    objc_setAssociatedObject(self, GZUIAlertViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, GZUIAlertViewBlockKey);
    if (block) {
        block(alertView, buttonIndex);
    }
}

@end
