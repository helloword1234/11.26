//
//  YKSCloseButton.m
//  YueKangSong
//
//  Created by gongliang on 15/5/27.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSCloseButton.h"

@implementation YKSCloseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    _closeButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 18, -16, 36, 36);
    [self addSubview:_closeButton];
}

@end
