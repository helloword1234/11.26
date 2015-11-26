//
//  YKSNetWorkManager.h
//  YueKangSong
//
//  Created by wkx on 15/9/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface YKSNetWorkManager : NSObject

+(AFHTTPRequestOperationManager *)shareManager;

@end
