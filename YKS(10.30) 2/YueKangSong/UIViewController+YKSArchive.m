//
//  UIViewController+YKSArchive.m
//  YueKangSong
//
//  Created by ios on 15/7/6.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "UIViewController+YKSArchive.h"

@implementation UIViewController (YKSArchive)


//默认选中归档,写入沙盒
+ (void)selectedAddressButtonArchiver:(int)selected
{
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"selected"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:selected]];
    [data writeToFile:fullPath atomically:YES];
    ;
}

//默认选中解归档,从沙盒取出
+ (int)selectedAddressButtonUnArchiver
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"selected"];
    NSData *readData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSNumber *selected = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return selected.intValue;
}


//把当前定位传入沙盒
+ (void)setMyLocation:(NSDictionary *)location
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/myLocation"];
    NSData *data= [NSKeyedArchiver archivedDataWithRootObject:location];
    [data writeToFile:fullPath atomically:YES];
    ;
}


//把当前定位从沙盒中取出
+ (NSDictionary *)selectedMyLocation
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/myLocation"];
    NSData *readData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSDictionary *location = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return location;
}

//选择地址归档,写入沙盒
+ (void)selectedAddressArchiver:(NSDictionary *)selectedAddress
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/selectedAddress"];
    NSData *data= [NSKeyedArchiver archivedDataWithRootObject:selectedAddress];
    [data writeToFile:fullPath atomically:YES];
    ;
}
//把城市写入沙盒
+ (void)selectedCityArchiver:(NSDictionary *)selectedAddress
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/city"];
    NSData *data= [NSKeyedArchiver archivedDataWithRootObject:selectedAddress];
    [data writeToFile:fullPath atomically:YES];
    
}

//取出城市
+ (NSDictionary *)selectedCityUnArchiver
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/city"];
    NSData *readData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSDictionary *selectedAddress = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return selectedAddress;
}


//选择地址解档,从沙盒取出
+ (NSDictionary *)selectedAddressUnArchiver
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/selectedAddress"];
    NSData *readData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSDictionary *selectedAddress = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return selectedAddress;
}

+ (void)deleteFile
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/selectedAddress"];
    [fileMgr removeItemAtPath:fullPath error:nil];
}

//选择地址归档,写入沙盒
+ (void)currentPriceArchiver:(CGFloat)price
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/price"];
    NSData *data= [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInteger:price]];
    [data writeToFile:fullPath atomically:YES];
    ;
}

//选择地址解档,从沙盒取出
+ (CGFloat)currentPriceUnArchiver
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/price"];
    NSData *readData = [[NSData alloc] initWithContentsOfFile:fullPath];
    NSNumber *currentPriceObj = [NSKeyedUnarchiver unarchiveObjectWithData:readData];
    return [currentPriceObj floatValue];
}

//删除沙盒里面的信息
+ (void)deletePriceFile
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullPath = [path stringByAppendingString:@"/price"];
    
    [fileMgr removeItemAtPath:fullPath error:nil];
}

@end
