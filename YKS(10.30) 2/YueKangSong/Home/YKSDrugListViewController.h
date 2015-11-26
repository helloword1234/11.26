//
//  YKSDrugListViewController.h
//  YueKangSong
//
//  Created by gongliang on 15/5/14.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YKSDrugListType) {
    YKSDrugListTypeSpecail = 1, //专题
    YKSDrugListTypeCategory = 2, //分类id
    YKSDrugListTypeSearchKey = 3 //搜索key
};

@interface YKSDrugListViewController : UIViewController

@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) NSString *specialId;
@property (assign, nonatomic) YKSDrugListType drugListType;

@end
