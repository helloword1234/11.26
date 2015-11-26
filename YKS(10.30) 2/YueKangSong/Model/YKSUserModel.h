//
//  GZUserInfo.h
//  GZTour
//
//  Created by gongliang on 14/12/2.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface YKSUserModel : NSObject

+ (instancetype)shareInstance;

+ (BOOL)isLogin;

+ (void)logout;

+ (void)loginSuccess:(NSDictionary *)userInfo;

+ (NSString *)nickName;

+ (NSString *)userEmail;

+ (NSString *)password;

+ (NSString *)token;

+ (NSString *)headImageString;

+ (UIImage *)headImage;

+ (NSString *)telePhone;

+ (NSString *)deviceToken;

/**
 *  设置昵称
 *
 *  @param nickName 昵称
 */
+ (void)setNickName:(NSString *)nickName;

/**
 *  设置新密码
 *
 *  @param newPassword 新密码
 */
+ (void)setnewPassword:(NSString *)newPassword;

/**
 *  设置新的手机号
 *
 *  @param telephone 手机号
 */
+ (void)setTelephone:(NSString *)telephone;

- (void)deleteCurrentSelectAddress;

@property (nonatomic, readonly) NSString *userId;

@property (nonatomic, readonly) NSString *nickName;

@property (nonatomic, readonly) NSString *userEmail;

@property (nonatomic, readonly) NSString *token;

@property (nonatomic, readonly) NSString *password; //是md5加密后的

@property (nonatomic, copy) NSString *headImageString;

@property (nonatomic, readonly) NSString *telePhone; //电话

@property (nonatomic, readonly) UIImage *headImage;

@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;

@property (nonatomic, strong) NSArray *addressLists;
@property (nonatomic, strong) NSDictionary *currentSelectAddress;

@property (nonatomic, strong) NSString *deviceToken;

@end
