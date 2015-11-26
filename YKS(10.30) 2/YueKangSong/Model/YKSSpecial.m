//
//  YKSSpecial.m
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSSpecial.h"

@implementation YKSSpecial

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _specialId = [[NSString alloc] initWithFormat:@"%@", dic[@"id"]];
        _title = dic[@"title"];
        _subtitle = dic[@"subtitle"];
        _specialDescription = dic[@"special_dec"];
        _iconString = dic[@"icon"];
        _middleIconString = dic[@"middleicon"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"tite = %@, subtitle = %@", _title, _subtitle];
}

@end

@implementation YKSSubSpecial

- (instancetype)initWithSpecialId:(NSString *)specialId
                           andDic:(NSDictionary *)dic {
    if (self = [super init]) {
        _specialId = [[NSString alloc] initWithFormat:@"%@", specialId];
        _title = dic[@"special_title"];
        _subtitle = dic[@"special_subtitle"];
        _specialDescription = dic[@"special_dec"];
        _iconString = dic[@"special_icon"];
        _sort = [[NSString alloc] initWithFormat:@"%@", dic[@"sort"]];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"tite = %@, subtitle = %@", _title, _subtitle];
}


@end
