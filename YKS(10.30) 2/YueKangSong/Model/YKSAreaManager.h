//
//  YKSAddressManager.h
//  YueKangSong
//
//  Created by gongliang on 15/5/19.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSAreaManager : NSObject

+ (void)getBeijingAreaInfo:(void (^)(id areaInfo))callback;

@end
