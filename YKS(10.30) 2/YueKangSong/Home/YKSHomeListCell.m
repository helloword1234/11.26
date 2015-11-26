//
//  YKSHomeListCell.m
//  YueKangSong
//
//  Created by gongliang on 15/5/28.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSHomeListCell.h"
#import "YKSSpecial.h"

@implementation YKSHomeListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHomeListInfo:(NSDictionary *)dic {
    NSArray *special1 = dic[@"list"];
    [special1 enumerateObjectsUsingBlock:^(NSDictionary *obj2, NSUInteger idx2, BOOL *stop2) {
        UILabel *nameLabel;
        UILabel *descriptionLabel;
        UIImageView *imageView;
        YKSSpecialView *specialView;
        nameLabel = self.tmpNameLabels[idx2];
        descriptionLabel = self.tmpDescriptionLabels[idx2];
        imageView = self.tmpImageViews[idx2];
        specialView = self.tmpSpecialViews[idx2];
        specialView.special = [[YKSSpecial alloc] initWithDic:obj2];
        
        nameLabel.text = specialView.special.title;
        descriptionLabel.text = specialView.special.specialDescription;
        [specialView tapActionCallback:^(YKSSpecialView *view) {
            if (self.tapAction) {
                self.tapAction(view.special);
            }
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:specialView.special.iconString]
                     placeholderImage:[UIImage imageNamed:@"default160"]];
    }];
}

@end



@implementation YKSHomeListSpecialOneCell

- (void)awakeFromNib {
    self.tmpSpecialViews = _specialViews;
    self.tmpNameLabels = _nameLabels;
    self.tmpDescriptionLabels = _descriptionLabels;
    self.tmpImageViews = _imageViews;
}

- (void)setHomeListInfo:(NSDictionary *)dic {
    [super setHomeListInfo:dic];
}

@end

@implementation YKSHomeListSpecialTwoCell

- (void)awakeFromNib {
    self.tmpSpecialViews = _specialViews;
    self.tmpNameLabels = _nameLabels;
    self.tmpDescriptionLabels = _descriptionLabels;
    self.tmpImageViews = _imageViews;
}


- (void)setHomeListInfo:(NSDictionary *)dic {
    [super setHomeListInfo:dic];
}

@end

@implementation YKSHomeListSpecialThreeCell

- (void)awakeFromNib {
    self.tmpSpecialViews = _specialViews;
    self.tmpNameLabels = _nameLabels;
    self.tmpDescriptionLabels = _descriptionLabels;
    self.tmpImageViews = _imageViews;
}

- (void)setHomeListInfo:(NSDictionary *)dic {
    [super setHomeListInfo:dic];
}

@end