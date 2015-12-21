//
//  YKSPlanDisPlayCell.m
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import "YKSPlanDisPlayCell.h"
#import "YKSTools.h"

@interface YKSPlanDisPlayCell ()
//显示药品展示图
@property (nonatomic,strong) UIImageView *image;
//显示药品名
@property (nonatomic,strong) UILabel *nameLabel;
//显示药品单价
@property (nonatomic,strong) UILabel *priceLabel;
//显示药品主要治疗信息
@property (nonatomic,strong) UILabel *medicineLabel;
//已售罄
@property (nonatomic,strong) UIImageView *nullImage;
//单位label
@property (nonatomic,strong) UILabel *companyLabel;
@end

@implementation YKSPlanDisPlayCell
- (UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc] init];
    }
    return _image;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
}
    return _nameLabel;
    
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
    }
    return _priceLabel;
    
}
- (UILabel *)medicineLabel
{
    if (!_medicineLabel) {
        _medicineLabel = [[UILabel alloc] init];
    }
    return _medicineLabel;
    
}
- (UIImageView *)nullImage
{
    if (!_nullImage) {
        _nullImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soldouts"]];
    }
    return _nullImage;
}
- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
    }
    return _companyLabel;
}

- (void)setDrugInfo:(NSDictionary *)drugInfo {
    _drugInfo = drugInfo;
    
    
    self.nullImage.frame = CGRectMake(SCREEN_WIDTH - 125, 10, 80, 60);
    
    if ([_drugInfo[@"repertory"] isEqualToString:@"0"])
    {
        self.nullImage.hidden = NO;
    }else{
        self.nullImage.hidden = YES;
    }
    [self.image sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
    self.image.frame = CGRectMake(20, 20, 50, 60);
    [self addSubview:self.image];
    self.nameLabel.text = DefuseNUllString(drugInfo[@"gtitle"]);
    self.nameLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.image.frame.origin.y, self.bounds.size.width - 40, 20);
    [self addSubview:self.nameLabel];
    
    self.companyLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 2, self.nameLabel.frame.size.width, 20);
    self.companyLabel.font = [UIFont systemFontOfSize:11];
    self.companyLabel.textColor = [UIColor lightGrayColor];
    self.companyLabel.text = DefuseNUllString(drugInfo[@"gstandard"]);
    [self addSubview:self.companyLabel];
    
    self.medicineLabel.text = DefuseNUllString(drugInfo[@"keywords"]);
    self.medicineLabel.font = [UIFont systemFontOfSize:15];
    self.medicineLabel.textColor = [UIColor lightGrayColor];
    self.medicineLabel.minimumScaleFactor = 11;
    [self.medicineLabel setNumberOfLines:0];

    [self.medicineLabel setFrame:CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.companyLabel.frame.origin.y + self.companyLabel.frame.size.height - 5, SCREEN_WIDTH - (self.image.frame.origin.x + self.image.frame.size.width + 10) - 20, 40)];
    [self addSubview:self.medicineLabel];
    self.priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];
    self.priceLabel.textColor = [UIColor redColor];
//    self.priceLabel.textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0];
    self.priceLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10,self.medicineLabel.frame.origin.y + self.medicineLabel.frame.size.height, 120, 20);
    [self addSubview:self.priceLabel];
    [self addSubview:self.nullImage];
}

@end







