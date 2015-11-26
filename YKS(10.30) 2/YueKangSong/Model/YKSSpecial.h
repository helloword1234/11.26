//
//  YKSSpecial.h
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSSpecial : NSObject

@property (copy, nonatomic) NSString *specialId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *specialDescription;
@property (copy, nonatomic) NSString *iconString;
@property (copy, nonatomic) NSString *middleIconString;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end


@interface YKSSubSpecial : NSObject

@property (copy, nonatomic) NSString *specialId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *specialDescription;
@property (copy, nonatomic) NSString *iconString;
@property (copy, nonatomic) NSString *sort;


- (instancetype)initWithSpecialId:(NSString *)specialId
                           andDic:(NSDictionary *)dic;

@end