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

//- (void)setDetail:(YKSDetails *)detail
//{
//    _detail = detail;
//    
//    //药品展示图
//    self.image.image = [UIImage imageNamed:detail.image];
//    self.image.frame = CGRectMake(20, 20, 50, 60);
//    [self addSubview:self.image];
//    self.nameLabel.text = detail.medicineName;
//    self.nameLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.image.frame.origin.y - 5, self.bounds.size.width - 40, 20);
//    [self addSubview:self.nameLabel];
//    
//    //药品主要治疗label
//    self.medicineLabel.text = detail.medicine;
//    self.medicineLabel.font = [UIFont systemFontOfSize:15];
//    self.medicineLabel.textColor = [UIColor lightGrayColor];
//    self.medicineLabel.minimumScaleFactor = 11;
//    [self.medicineLabel setNumberOfLines:0];
//    CGSize constraint = CGSizeMake(self.bounds.size.width - (10.0f  * 2), 20000.0f);
//    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    CGSize size = [detail.medicine boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    [self.medicineLabel setFrame:CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 5, 300, MAX(size.height,44.0f))];
//    [self addSubview:self.medicineLabel];
//    
//    
//    //价钱label
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",detail.money];
//    self.priceLabel.textColor = [UIColor redColor];
//    self.priceLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + self.medicineLabel.frame.size.height - 10, 120, 20);
//    [self addSubview:self.priceLabel];
//}

- (void)setDrugInfo:(NSDictionary *)drugInfo {
    _drugInfo = drugInfo;
    [self.image sd_setImageWithURL:[NSURL URLWithString:drugInfo[@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
    self.image.frame = CGRectMake(20, 20, 50, 60);
    [self addSubview:self.image];
    self.nameLabel.text = DefuseNUllString(drugInfo[@"gtitle"]);
    self.nameLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.image.frame.origin.y - 5, self.bounds.size.width - 40, 20);
    [self addSubview:self.nameLabel];
    self.medicineLabel.text = DefuseNUllString(drugInfo[@"keywords"]);
    self.medicineLabel.font = [UIFont systemFontOfSize:15];
    self.medicineLabel.textColor = [UIColor lightGrayColor];
    self.medicineLabel.minimumScaleFactor = 11;
    [self.medicineLabel setNumberOfLines:0];
    
    
    CGSize constraint = CGSizeMake(self.bounds.size.width - (10.0f  * 2), 20000.0f);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGSize size = [DefuseNUllString(drugInfo[@"keywords"]) boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [self.medicineLabel setFrame:CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height - 5, 300, MAX(size.height,44.0f))];
    [self addSubview:self.medicineLabel];
    
    self.priceLabel.attributedText = [YKSTools priceString:[drugInfo[@"gprice"] floatValue]];
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.frame = CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + 10, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + self.medicineLabel.frame.size.height - 10, 120, 20);
    [self addSubview:self.priceLabel];
    
}

@end







