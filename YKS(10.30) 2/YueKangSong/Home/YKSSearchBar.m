//
//  YKSSearchBar.m
//  YueKangSong
//
//  Created by gongliang on 15/5/26.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSearchBar.h"

@implementation YKSSearchBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    [self setShowsCancelButton:YES animated:YES];
//    self.frame = CGRectMake(40, 0, SCREEN_WIDTH-80, 30);
    
    
    self.placeholder = @"搜索你的症状或药品名称";
    self.tintColor = kNavigationBar_back_color;
    [self becomeFirstResponder];
    @autoreleasepool {
        for (UIButton* markButton in [self.subviews[0] subviews]) {
            if ([markButton isKindOfClass:[UIButton class]]) {
                [markButton setTitle:@"取消" forState:UIControlStateNormal];
                [markButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
}


@end
