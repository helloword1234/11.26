//
//  YKSNetWorkManager.m
//  YueKangSong
//
//  Created by wkx on 15/9/17.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSNetWorkManager.h"

static AFHTTPRequestOperationManager *manager;

@implementation YKSNetWorkManager

+(AFHTTPRequestOperationManager *)shareManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        manager=[[AFHTTPRequestOperationManager alloc]init];
        
    });
    
    return manager;

}

@end
