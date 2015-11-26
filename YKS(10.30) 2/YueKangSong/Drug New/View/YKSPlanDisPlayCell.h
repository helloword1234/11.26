//
//  YKSPlanDisPlayCell.h
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSDetails.h"
/*
 展开药师推存方案cell 
 */

@interface YKSPlanDisPlayCell : UITableViewCell
//公开属性  给外界传值
@property (nonatomic,strong)YKSDetails *detail;
@property (strong, nonatomic) NSDictionary *drugInfo;

@end
