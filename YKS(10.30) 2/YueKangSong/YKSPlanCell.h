//
//  YKSPlanCell.h
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EachGroupDetail.h"
/*
    遍历药师推荐药品 将视图显示到cell上
 */
@interface YKSPlanCell : UITableViewCell
@property (nonatomic,strong) EachGroupDetail *details;
@property (strong, nonatomic) NSArray *datas;
@end
