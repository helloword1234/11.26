//
//  UIViewController+YKSArchive.h
//  YueKangSong
//
//  Created by ios on 15/7/6.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YKSArchive)

//取出城市
+ (NSDictionary *)selectedCityUnArchiver;

//把城市写入沙盒
+ (void)selectedCityArchiver:(NSDictionary *)selectedAddress;

//选择地址归档,写入沙盒
+ (void)selectedAddressArchiver:(NSDictionary *)selectedAddress;

//选择地址解档,从沙盒取出
+ (NSDictionary *)selectedAddressUnArchiver;

//默认选中归档,写入沙盒
+ (void)selectedAddressButtonArchiver:(int)selected;

//默认选中解归档,从沙盒取出
+ (int)selectedAddressButtonUnArchiver;

//删除沙盒地址文件
+ (void)deleteFile;



//选择地址归档,写入沙盒
+ (void)currentPriceArchiver:(CGFloat)price;

//选择地址解档,从沙盒取出
+ (CGFloat)currentPriceUnArchiver;

//删除沙盒里面的信息
+ (void)deletePriceFile;

//把当前定位传入沙盒
+ (void)setMyLocation:(NSDictionary *)location;

//把当前定位从沙盒中取出
+ (NSDictionary *)selectedMyLocation;


@end
