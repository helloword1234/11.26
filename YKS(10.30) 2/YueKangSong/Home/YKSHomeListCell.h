//
//  YKSHomeListCell.h
//  YueKangSong
//
//  Created by gongliang on 15/5/28.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSSpecialView.h"

@interface YKSHomeListCell : UITableViewCell

- (void)setHomeListInfo:(NSDictionary *)dic;
@property (nonatomic, strong) NSDictionary *info;

@property (nonatomic, strong) void(^tapAction)(YKSSpecial *special);

@property (strong, nonatomic) NSArray *tmpSpecialViews;
@property (strong, nonatomic) NSArray *tmpNameLabels;
@property (strong, nonatomic) NSArray *tmpDescriptionLabels;
@property (strong, nonatomic) NSArray *tmpImageViews;


@end


@interface YKSHomeListSpecialOneCell : YKSHomeListCell

@property (strong, nonatomic) IBOutletCollection(YKSSpecialView) NSArray *specialViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *descriptionLabels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@interface YKSHomeListSpecialTwoCell : YKSHomeListCell

@property (strong, nonatomic) IBOutletCollection(YKSSpecialView) NSArray *specialViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *descriptionLabels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end

@interface YKSHomeListSpecialThreeCell : YKSHomeListCell

@property (strong, nonatomic) IBOutletCollection(YKSSpecialView) NSArray *specialViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *descriptionLabels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@end