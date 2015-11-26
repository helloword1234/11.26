//
//  EachGroupDetail.h
//  YKSDrugPushing
//
//  Created by TT on 15/10/25.
//  Copyright © 2015年 Saintly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EachGroupDetail : NSObject


//方案
@property (nonatomic,strong) NSString *plan;
//方案总价
@property (nonatomic,assign) float price;
//运费
@property (nonatomic,strong) NSString *freight;
//cell数据
@property (nonatomic,strong) NSArray *cellData;
//表头数据
@property (nonatomic,strong) NSArray *formInformation;
@end
