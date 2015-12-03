//
//  YKSTools.h
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YKSTools : NSObject

+ (NSString *)md5:(NSString *)str;

+ (NSString *)getDeviceAdid;
// yyyy-mm-dd
+ (NSString *)formatterDateStamp:(NSInteger)timestamp;

// YYYY-MM-dd hh:mm:ss
//2014-12-16 11:02:22
+ (NSString *)formatterTimeStamp:(NSInteger)timestamp;
+ (NSString *)formatterTimeStamp2:(NSInteger)timestamp;

+ (BOOL)mobilePhoneFormatter:(NSString *)mobilephone;

+ (NSAttributedString *)priceString:(CGFloat)price;
+ (NSAttributedString *)priceString:(CGFloat)price smallSize:(CGFloat)smallSize largeSize:(CGFloat)largeSize;

+(NSString *)nameFormatter:(NSString *)name;
+(NSString *)detailAddress:(NSString *)address;

+ (void)login:(UIViewController *)parentViewController;

+ (void)call:(NSString *)telephone inView:(UIView *)view;

+ (void)insertEmptyImage:(NSString *)imageName text:(NSString *)text view:(UIView *)view;

+ (void)showToastMessage:(NSString *)message inView:(UIView *)view;

+ (NSString *)titleByOrderStatus:(YKSOrderStatus)status;

+ (NSArray *)returnArray:(NSArray *)array;
+ (NSDictionary *)returnDic:(NSDictionary *)params;

//读取物流价格
+ (void)showFreightPriceTextByTotalPrice:(CGFloat)totalPrice
                                callback:(void(^)(NSAttributedString *totalPriceString, NSString *freightPriceString))callback;

@end
