//
//  YKSConstants.h
//  YueKangSong
//
//  Created by gongliang on 15/5/12.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSUIConstants.h"

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define kNavigationBar_back_color [UIColor colorWithRed: 0.263 green: 0.647 blue: 0.973 alpha: 1]
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static const CGFloat kCycleHeight = 140;

#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCRENN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define IS_NULL(x)          (!x || [x isKindOfClass:[NSNull class]])
#define IS_EMPTY_STRING(x)  (IS_NULL(x) || [x isEqual:@""] || [x isEqual:@"(null)"])

#define DefuseNUllString(x) (!IS_EMPTY_STRING(x) ? x : @"")


#pragma mark - API

#define ServerSuccess(x)        (x && ([x[@"code"] integerValue] == 200))

#define kServerPhone @"400-186-6606"

#define kShowWelcome @"1.0"

#define kBaseURLString @"http://api.yuekangsong.com"
//#define kBaseURLString @"http://123.57.175.170"

#define ClientKey @"ios_yks_client"

#define BaiduMapGeocoderApi @"http://api.map.baidu.com/geocoder/v2/" //http://developer.baidu.com/map/index.php?title=webapi/guide/webservice-geocoding
#define BaiduMapPlaceApi @"http://api.map.baidu.com/place/v2/search"
#define BaiduMapAK  @"GQ4jG3c4Ml5C5VGgS1fpRya0"

#define kUMAppkey @"5567ff6e67e58e9b70001f67"


#define kDefaultTimeOutInterval 10.0f


typedef NS_ENUM(NSInteger, YKSOrderStatus) {
    YKSOrderStatusCancel = -1, //订单取消
    YKSOrderStatusPending = 1, //待处理
    YKSOrderStatusConfirm = 2, //卖家确认
    YKSOrderStatusShipping = 3, //配送中
    YKSOrderStatusReceived = 4 //订单已经签收
};

typedef NS_ENUM(NSInteger, YKSCouponStatus) {
    YKSCouponStatusNever = 0,  // 未使用
    YKSCouponStatusDid =  1,  // 已使用
    YKSCouponStatusPast = 2   // 已过期
};


 // 微信支付的渠道选择
typedef NS_OPTIONS(NSUInteger, PingppBtnOption) {
    PingppBtnAlipay = 1 << 0, // 支付宝
    PingppBtnWx = 1 << 1,     // 微信
    PingppBtnUp = 1 << 2,     // 银联
    PingppBtnBfb = 1 << 3     // 百度钱包
};



