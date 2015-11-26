//
//  YKSReleaseButton.m
//  YKSPharmacistRecommend
//
//  Created by TT on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import "YKSReleaseButtonCell.h"
#import "YKSTools.h"

@interface YKSReleaseButtonCell ()

//显示方案
@property (nonatomic,strong) UILabel *planLabel;


@end

@implementation YKSReleaseButtonCell
- (UIImageView *)selectedImage
{
    if (!_selectedImage) {
        _selectedImage = [[UIImageView alloc] init];
    }
    return _selectedImage;
}
- (UILabel *)planLabel
{
    if(!_planLabel)
    {
        _planLabel = [[UILabel alloc] init];
    }
    return _planLabel;
}
- (UIButton *)clickButton
{
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _clickButton;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
    }
    return _priceLabel;
}
- (instancetype)initWithPrice:(float)price andSection:(NSString *)section andFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.frame = frame;
        
        self.priceLabel.frame = CGRectMake(65, 10, 90, 13);
        self.priceLabel.attributedText = [YKSTools priceString:price];
        self.priceLabel.font = [UIFont systemFontOfSize:15.0f];
//        self.priceLabel.backgroundColor = [UIColor greenColor];
        self.priceLabel.textColor = [UIColor redColor];

        
        self.planLabel.frame = CGRectMake(20, 10, 50, 13);
        self.planLabel.text = section;
        self.planLabel.font = [UIFont systemFontOfSize:13.0f];
//        self.planLabel.backgroundColor = [UIColor redColor];
        self.planLabel.textColor = [UIColor lightGrayColor];

        
        self.selectedImage.frame = CGRectMake(self.frame.size.width - 50, 4, 22, 22);


        
        self.clickButton.frame = CGRectMake(self.frame.size.width - 50, 5, 30, 30);
        self.clickButton.backgroundColor = [UIColor clearColor];
        [self.clickButton addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.priceLabel];
        [self addSubview:self.planLabel];
        [self addSubview:self.selectedImage];
        [self addSubview:self.clickButton];

    }
    return self;
}

- (void)addButton:(UIButton *)button
{
    [self.delegate clickButton:button];
    button.selected = !button.selected;
    if (button.selected) {
        self.priceLabel.hidden = YES;
    }else{
        self.priceLabel.hidden = NO;
    }
}

@end
