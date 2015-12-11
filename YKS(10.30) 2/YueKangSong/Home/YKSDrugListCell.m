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

@implementation YKSDrugListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDrugInfo:(NSDictionary *)drugInfo {
    _drugInfo = drugInfo;

    _recipeFlagView.hidden = ![_drugInfo[@"gtag"] boolValue];
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
    _titleLabel.text = DefuseNUllString(drugInfo[@"gtitle"]);
    _contentLabel.text = DefuseNUllString(drugInfo[@"keywords"]);
    _priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];

//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soldouts"]];
//    image.contentMode = UIViewContentModeScaleToFill;
//    image.frame = CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width - 40, _contentLabel.frame.size.height + _contentLabel.frame.origin.y + 15, 40, 40);
//    [self addSubview:image];
    
    self.sellOverIV.image = [UIImage imageNamed:@"soldouts"];
//    self.sellOverIV.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"_drugInfo ============ %@",_drugInfo[@"repertory"]);
    self.sellOverIV.backgroundColor = [UIColor blueColor];
    NSString *s = _drugInfo[@"repertory"];
    self.sellOverIV.hidden = s.boolValue;
    
    
}

@end
