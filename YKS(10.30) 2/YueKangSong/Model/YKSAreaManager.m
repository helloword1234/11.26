//
//  YKSAddressManager.m
//  YueKangSong
//
//  Created by gongliang on 15/5/19.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSAreaManager.h"
#import "YKSConstants.h"
#import "GZBaseRequest.h"

static NSString *const kAreaName = @"area.plist";

@interface YKSAreaManager()

@end

@implementation YKSAreaManager

+ (void)getBeijingAreaInfo:(void (^)(id areaInfo))callback {
    NSString *areaPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:kAreaName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:areaPath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:areaPath];
        if (callback) {
            [self parserBeijingAreaInfo:dic callback:callback];
        }
    } else {
        [GZBaseRequest areaInfoCallBack:^(id responseObject, NSError *error) {
            if (ServerSuccess(responseObject)) {
                //NSLog(@"responseObject = %@", responseObject);
                NSDictionary *dic = responseObject[@"data"];
                if (dic) {
                    if (callback) {
                        [self parserBeijingAreaInfo:dic callback:callback];
                    }
                    if ([dic writeToFile:areaPath atomically:YES]) {
                        NSLog(@"写入成功");
                    }
                }
            } else {
                if (callback) {
                    callback(nil);
                }
            }
        }];
    }
}

+ (void)parserBeijingAreaInfo:(NSDictionary *)dic callback:(void (^)(id areaInfo))callback {
    NSMutableDictionary *beijingArea = [NSMutableDictionary new];
    NSDictionary *province = [dic[@"parea"] firstObject];
    beijingArea[@"province"] = province;
    NSArray *citys = dic[@"subarea"][province[@"code"]];
    beijingArea[@"city"] = citys;
    for (NSDictionary *temp in citys) {
        beijingArea[@"county"] = @{temp[@"code"]: dic[@"subarea"][[citys firstObject][@"code"]]};
    }
    if (callback) {
        callback(beijingArea);
    }
}

@end
