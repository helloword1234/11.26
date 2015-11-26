//
//  NSObject+Json.m
//  BusKingdom
//
//  Created by gongliang on 13-8-27.
//  Copyright (c) 2013年 yongche. All rights reserved.
//

#import "NSObject+Json.h"

@implementation NSObject (Json)

/*
 iOS5 以后把json数据封装起来了，效率上比JSONKit效率要高一些
 */
//将object转化成json格式
- (NSString *)objectToJsonString
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        //创超一个json从Data,NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData
                                                    encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    
    return nil;
}

//将json转化为object
- (id)jsonStringToObject
{
    NSString *jsonString = (NSString *)self;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&error];
    return object;
}

@end
