//
//  YKSPlanCell.m
//  YKSPharmacistRecommend
//
//  Created by ydz on 15/10/22.
//  Copyright © 2015年 ydz. All rights reserved.
//

#import "YKSPlanCell.h"
#import "YKSDetails.h"

@interface YKSPlanCell ()

@end

@implementation YKSPlanCell


-(void)setDatas:(NSArray *)datas{
    //通过set方法加载控制器传递过来的数组（数组中的数据是从服务器请求的）
    _datas = datas;
    for (int x = 0 ; x < datas.count; x++) {
        if (x > datas.count) {
            break;
        }
        UIWindow *window = [[[UIApplication sharedApplication] windows]lastObject];
        NSLog(@"我需要的地址是:%@",datas[x][@"glogo"]);
        UIImageView *image = [[UIImageView alloc]init];
        //datas[x][@"glogo"]是服务器返回的图片的地址
        [image sd_setImageWithURL:[NSURL URLWithString:datas[x][@"glogo"]] placeholderImage:[UIImage imageNamed:@"default160"]];
        CGFloat imageViewY = 10;
        CGFloat imageViewW = (window.bounds.size.width - 64 - 3 * 20)/4;
        CGFloat imageViewH = 65;
        CGFloat imageViewX = 32 + x * 20 + x * imageViewW;
        image.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        //[self.imageArray addObject:image];
        [self addSubview:image];
    }


}


@end
