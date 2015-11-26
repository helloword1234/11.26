//
//  YKSRecommenViewController.h
//  YKSDrugPushing
//
//  Created by TT on 15/10/25.
//  Copyright © 2015年 Saintly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSFormInformation.h"
#import "YKSDrugListViewController.h"
//typedef NS_ENUM(NSInteger, YKSDrugListType1) {
//    YKSDrugListTypeSpecail = 1, //专题
//    YKSDrugListTypeCategory = 2, //分类id
//    YKSDrugListTypeSearchKey = 3 //搜索key
//};

@interface YKSRecommenViewController : UITableViewController
@property (strong, nonatomic) NSString *specialId;
//每一个当前页面的"症状名称""临床症状""药师推荐"
@property (nonatomic,strong) YKSFormInformation *formInformation;
@property (assign, nonatomic) YKSDrugListType drugListType;
@property (strong, nonatomic) NSArray *datas;
@end
