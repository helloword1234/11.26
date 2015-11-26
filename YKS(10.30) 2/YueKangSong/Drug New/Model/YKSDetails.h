//
//  YKSDetails.h
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSDetails : NSObject
//商品图片
@property (nonatomic,strong) NSString *image;
//商品名
@property (nonatomic,strong) NSString *medicineName;
//商品信息
@property (nonatomic,strong) NSString *medicine;
//商品单价
@property (nonatomic,assign) float money;


- (instancetype)initWithDisplayImage:(NSString *)image andNameLabel:(NSString *)name andMedicineLabel:(NSString *)medicineLabel andMoney:(float)money;
@end
