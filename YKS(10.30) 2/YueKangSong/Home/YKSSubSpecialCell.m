//
//  YKSSubSpecialCell.m
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSubSpecialCell.h"

@implementation YKSSubSpecialCell

- (void)awakeFromNib {
    // Initialization code
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
