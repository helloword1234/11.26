//
//  YKSDrugListCell.m
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSDrugListCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YKSConstants.h"
#import "YKSTools.h"
@interface YKSDrugListCell ()



@end

@implementation YKSDrugListCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setDrugInfo:(NSDictionary *)drugInfo {
    _drugInfo = drugInfo;

    _recipeFlagView.hidden = ![_drugInfo[@"gtag"] boolValue];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
    _titleLabel.text = DefuseNUllString(drugInfo[@"gtitle"]);
    
    _companyLabel.font = [UIFont systemFontOfSize:12];
    _companyLabel.text = _drugInfo[@"gstandard"];
    _companyLabel.textColor = [UIColor lightGrayColor];

    _contentLabel.text = DefuseNUllString(drugInfo[@"keywords"]);
    _priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];

    self.sellOverIV.image = [UIImage imageNamed:@"soldouts"];
    NSLog(@"_drugInfo ============ %@",_drugInfo[@"repertory"]);
    NSString *s = _drugInfo[@"repertory"];
    self.sellOverIV.hidden = s.boolValue;
    
    
}

@end
