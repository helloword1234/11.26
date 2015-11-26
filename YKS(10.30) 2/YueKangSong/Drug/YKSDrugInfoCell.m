//
//  YKSDrugInfoCell.m
//  YueKangSong
//
//  Created by gongliang on 15/5/16.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSDrugInfoCell.h"

@implementation YKSDrugInfoCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation YKSDrugNameCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineWidthLayout.constant = 0.5f;
}

@end

@implementation YKSDrugActionCell
@end

@implementation YKSDrugDescribeCell
- (void)layoutSubviews {
    [super layoutSubviews];

    self.lineHeight.constant = 0.5f;
}
@end