//
//  YKSSpecialView.m
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSpecialView.h"
#import <objc/runtime.h>

static const void *kYKSSpecialViewCallbackKey = &kYKSSpecialViewCallbackKey;

@implementation YKSSpecialView

- (void)dealloc {
    objc_setAssociatedObject(self, kYKSSpecialViewCallbackKey, nil, OBJC_ASSOCIATION_COPY);
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setup {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"home_button_hightlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[button]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(button)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[button]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(button)]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)tap:(UIButton *)sender {
//    self.backgroundColor = [UIColor whiteColor];
    void (^callback)(YKSSpecialView *view) = objc_getAssociatedObject(self, kYKSSpecialViewCallbackKey);
    if (callback) {
        callback(self);
    }
}

- (void)tapActionCallback:(void (^)(YKSSpecialView *view))callback {
    objc_setAssociatedObject(self, kYKSSpecialViewCallbackKey, callback, OBJC_ASSOCIATION_COPY);
}


@end
