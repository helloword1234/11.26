//
//  NSObject+Json.h
//  BusKingdom
//
//  Created by gongliang on 13-8-27.
//  Copyright (c) 2013年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Json)

//将object转化成json格式
- (NSString *)objectToJsonString;
//将json转化为object
- (id)jsonStringToObject;

@end
