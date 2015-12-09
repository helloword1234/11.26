//
//  YKSTools.m
//  YueKangSong
//
//  Created by gongliang on 15/5/13.
//  Copyright (c) 2015年 YKS. All rights reserved.
//

#import "YKSTools.h"
#import <commoncrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import "YKSConstants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "YKSAppDelegate.h"


@implementation YKSTools

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, (uint32_t)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)getDeviceAdid {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
}

+ (BOOL)mobilePhoneFormatter:(NSString *)mobilephone {
    if (IS_EMPTY_STRING(mobilephone)) {
        return NO;
    }
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[0-9])|(18[0-9])|(14[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    if (![phoneTest evaluateWithObject:mobilephone]) {
        return NO;
    }
    return YES;
}

+(NSString *)nameFormatter:(NSString *)name
{
    
    NSString *nameRegex = @"[^\u4e00-\u9fa5a-zA-Z]";
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              
                                              nameRegex options:0 error:nil];
    name  = [regularExpression stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, name.length) withTemplate:@""];
    
    return name;
}

+(NSString *)detailAddress:(NSString *)address
{
    NSString *addressRegex = @"[^\u4e00-\u9fa5a-zA-Z0-9]";
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              
                                              addressRegex options:0 error:nil];
    address  = [regularExpression stringByReplacingMatchesInString:address options:0 range:NSMakeRange(0, address.length) withTemplate:@""];
    
    return address;
    
}

+ (NSString *)formatterDateStamp:(NSInteger)timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter2 stringFromDate:confromTimesp];
}

// YYYY-MM-dd hh:mm:ss
//2014-12-16 11:02:22
+ (NSString *)formatterTimeStamp:(NSInteger)timestamp
{
    NSTimeInterval time = timestamp;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *day = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:confromTimesp]];
    return day;
}

//2014-12-16 11:02:
+ (NSString *)formatterTimeStamp2:(NSInteger)timestamp
{
    NSTimeInterval time = timestamp;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *day = [NSString stringWithFormat:@"%@", [dateFormatter2 stringFromDate:confromTimesp]];
    return day;
}

+ (NSAttributedString *)priceString:(CGFloat)price {
    return [self priceString:price smallSize:11.0f largeSize:19.0f];
}

+ (void)showToastMessage:(NSString *)message inView:(UIView *)view
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:view.bounds];
    hud.yOffset=-50;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

+ (NSAttributedString *)priceString:(CGFloat)price smallSize:(CGFloat)smallSize largeSize:(CGFloat)largeSize {
    NSString *priceString = [NSString stringWithFormat:@"￥%0.2f", price];
    NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:smallSize],
                                     NSForegroundColorAttributeName: (id)UIColorFromRGB(0xE9460B)}
                             range:NSMakeRange(0, 1)];
    [attribuedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:largeSize],
                                     NSForegroundColorAttributeName: (id)UIColorFromRGB(0xE9460B)}
                             range:NSMakeRange(1, priceString.length - 1)];
    return attribuedString;
}

+ (void)login:(UIViewController *)parentViewController
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"YKSLoginViewController"];
    [parentViewController.navigationController pushViewController:vc animated:YES];
}

+ (void)call:(NSString *)telephone inView:(UIView *)view
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", telephone]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSString *message = [NSString stringWithFormat:@"是否拨打电话%@", telephone];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        [alert callBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != alertView.cancelButtonIndex) {
                if (url) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
    }
}

+ (void)insertEmptyImage:(NSString *)imageName text:(NSString *)text view:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [view insertSubview:imageView atIndex:0];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor lightGrayColor];
    [view insertSubview:label atIndex:1];
    [label sizeToFit];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:imageView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:5.0]];
}

+ (NSString *)titleByOrderStatus:(YKSOrderStatus)status {
    if (status == YKSOrderStatusPending) {
        return @"待处理";
    } else if (status == YKSOrderStatusShipping) {
        return @"配送中";
    } else if (status == YKSOrderStatusReceived) {
        return @"已签收";
    }else if (status == YKSOrderStatusCancel)
    {
        return @"已取消";
    }
    return @"";
}

+ (NSArray *)returnArray:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger index,BOOL *stop){
        if (obj == [NSNull null]) {
            //            [mutableArray addObject:@""];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [mutableArray addObject:[self returnArray:array]];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutableArray addObject:[self returnDic:obj]];
        } else {
            [mutableArray addObject:obj];
        }
    }];
    return mutableArray;
}

+ (NSDictionary *)returnDic:(NSDictionary *)params {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (obj == [NSNull null]) {
            //            [dict setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [dict setObject:[self returnArray:obj] forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [dict setObject:[self returnDic:obj] forKey:key];
        } else {
            [dict setObject:obj forKey:key];
        }
    }];
    return dict;
}

+ (void)showFreightPriceTextByTotalPrice:(CGFloat)totalPrice
                                callback:(void(^)(NSAttributedString *totalPriceString, NSString *freightPriceString))callback {
    if ([YKSAppDelegate sharedAppDelegate].baseInfo) {
        NSDictionary *dic = [YKSAppDelegate sharedAppDelegate].baseInfo;
        if (totalPrice == 0) {
            callback([self priceString:0], @"免运费");
            return ;
        }
        
        if ([dic[@"fillFreeServiceMoney"] floatValue] <= totalPrice) {
            callback([self priceString:totalPrice], @"免运费");
        } else {
            NSString *tempString = [[NSString alloc] initWithFormat:@"运费: %0.2f", [dic[@"serviceMoney"] floatValue]];
            callback([self priceString:totalPrice + [dic[@"serviceMoney"] floatValue]], tempString);
        }
    }
}

@end
