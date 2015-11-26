
//
//  YKSDetails.m
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import "YKSDetails.h"
@interface YKSDetails()

@end

@implementation YKSDetails

- (instancetype)initWithDisplayImage:(NSString *)image andNameLabel:(NSString *)name andMedicineLabel:(NSString *)medicineLabel andMoney:(float)money
{
    self = [super init];
    if (self) {
        self.image = image;
        self.medicineName = name;
        self.money = money;
        self.medicine = medicineLabel;
    }
    
    return self;
}
@end
