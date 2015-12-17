//
//  GZUserInfo.m
//  GZTour
//
//  Created by gongliang on 14/12/2.
//  Copyright (c) 2014年 . All rights reserved.
//
#import "YKSUserModel.h"
#import "YKSTools.h"
#import "YKSAppDelegate.h"
#import "GZBaseRequest.h"
NSString * const kUserInfo = @"userInfo";
@interface YKSUserModel()

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong, readwrite) NSString *userId;

@property (nonatomic, strong, readwrite) NSString *token;

@property (nonatomic, strong, readwrite) NSString *nickName;

@property (nonatomic, strong, readwrite) NSString *userEmail;

@property (nonatomic, strong, readwrite) NSString *password;

@property (nonatomic, strong, readwrite) NSString *telePhone;

@end
@implementation YKSUserModel

@synthesize userInfo = _userInfo;
@synthesize currentSelectAddress = _currentSelectAddress;
@synthesize addressLists = _addressLists;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static YKSUserModel *model = nil;
    dispatch_once(&onceToken, ^{
        model = [YKSUserModel new];
    });
    return model;
}

+ (void)loginSuccess:(NSDictionary *)userInfo {
    YKSUserModel *UserModel = [YKSUserModel shareInstance];
    UserModel.userInfo = userInfo;
}

+ (void)setNickName:(NSString *)nickName {
    [YKSUserModel shareInstance].nickName = nickName;
    NSMutableDictionary *dic = [[YKSUserModel shareInstance].userInfo mutableCopy];
    dic[@"nick_name"] = nickName;
    [YKSUserModel shareInstance].userInfo = dic;
}

+ (void)setnewPassword:(NSString *)newPassword {
    [YKSUserModel shareInstance].password = newPassword;
    NSMutableDictionary *dic = [[YKSUserModel shareInstance].userInfo mutableCopy];
    dic[@"password"] = newPassword;
    [YKSUserModel shareInstance].userInfo = dic;
}

+ (void)setTelephone:(NSString *)telephone {
    [YKSUserModel shareInstance].telePhone = telephone;
    NSMutableDictionary *dic = [[YKSUserModel shareInstance].userInfo mutableCopy];
    dic[@"phone"] = telephone;
    [YKSUserModel shareInstance].userInfo = dic;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *tempUserInfo = [userInfo mutableCopy];
    if (!IS_EMPTY_STRING(userInfo[@"user_id"])) {
        _userId = userInfo[@"user_id"];
    }

        
    if (IS_EMPTY_STRING(tempUserInfo[@"nick_name"])) {
        tempUserInfo[@"nick_name"] = @"";
    }
    _nickName = tempUserInfo[@"nick_name"];
    
    _token = tempUserInfo[@"token"] ? tempUserInfo[@"token"] : @"";
    
    if (!IS_EMPTY_STRING(tempUserInfo[@"head_image_string"])) {
        _headImageString = tempUserInfo[@"head_image_string"];
    }
    if (!IS_EMPTY_STRING(tempUserInfo[@"password"])) {
        _password = tempUserInfo[@"password"];
    }
    
    if (IS_EMPTY_STRING(tempUserInfo[@"phone"])) {
        tempUserInfo[@"phone"] = @"";
    }
    
    _telePhone = tempUserInfo[@"phone"];
    
    _userInfo = tempUserInfo;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userInfo forKey:kUserInfo];
    [userDefaults synchronize];
}

- (NSDictionary *)userInfo {
    if (!_userInfo) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _userInfo = [userDefaults objectForKey:kUserInfo];
    }
    return _userInfo;
}

- (NSString *)userId {
    if (!_userId) {
        _userId = self.userInfo[@"user_id"];
    }
    return _userId;
}

- (NSString *)userName {
    if (!_nickName) {
        _nickName = self.userInfo[@"nick_name"];
    }
    return _nickName;
}

- (NSString *)userEmail {
    if (!_userEmail) {
        _userEmail = self.userInfo[@"user_email"];
    }
    return _userEmail;
}

- (NSString *)token {
    if (!_token) {
        _token = self.userInfo[@"token"];
    }
    return _token;
}


- (UIImage *)headImage {
    if (!IS_EMPTY_STRING(_headImageString)) {
        return [UIImage imageNamed:_headImageString];
    }
    return nil;
}

- (NSString *)telePhone {
    if (!_telePhone) {
        _telePhone = self.userInfo[@"phone"];
    }
    return _telePhone ? _telePhone : @"";
}

- (void)setHeadImageString:(NSString *)headImageString {
    _headImageString = headImageString;
    NSMutableDictionary *mutableUserinfo = [self.userInfo mutableCopy];
    [mutableUserinfo setObject:_headImageString forKey:@"head_image_string"];
    self.userInfo = mutableUserinfo;
}

- (void)setAddressLists:(NSArray *)addressLists {
    [[NSUserDefaults standardUserDefaults] setObject:[YKSTools returnArray:addressLists] forKey:@"kAddressLists"];
    _addressLists = addressLists;
}

- (NSArray *)addressLists {
    if (!_addressLists) {
        _addressLists = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAddressLists"];
    }
    return _addressLists;
}

//删除当前选中地址
- (void)deleteCurrentSelectAddress {
    [[NSUserDefaults standardUserDefaults] setObject:[YKSTools returnDic:nil] forKey:@"kCurrentSelectAddress"];
//    if (![_currentSelectAddress isEqual:nil]) {
//        [GZBaseRequest restartShoppingCartBygids:nil callback:^(id responseObject, NSError *error) {
//        }];
//    }
    _currentSelectAddress=nil;
}

//设置当前选中地址
- (void)setCurrentSelectAddress:(NSDictionary *)currentSelectAddress {
    [[NSUserDefaults standardUserDefaults] setObject:[YKSTools returnDic:currentSelectAddress] forKey:@"kCurrentSelectAddress"];
    
    NSLog(@"%@",currentSelectAddress);
    
//    if (![_currentSelectAddress isEqual:currentSelectAddress]) {
//        [GZBaseRequest restartShoppingCartBygids:nil callback:^(id responseObject, NSError *error) {
//        }];
//    }
    
    
    _currentSelectAddress = currentSelectAddress;
    if ([_currentSelectAddress[@"sendable"] integerValue] == 0) {
        [YKSTools showToastMessage:@"暂不支持配送到该区域, 我们会尽快开通" inView:[YKSAppDelegate sharedAppDelegate].window];
    }
}


//取出当前选中地址
- (NSDictionary *)currentSelectAddress {
    if (!_currentSelectAddress) {
        _currentSelectAddress = [[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"kCurrentSelectAddress"];
    }
    return _currentSelectAddress;
}

+ (NSString *)userId {
    return [YKSUserModel shareInstance].userId;
}

+ (NSString *)nickName {
    return [YKSUserModel shareInstance].userName;
}

+ (NSString *)userEmail {
    return [YKSUserModel shareInstance].userEmail;
}

+ (NSString *)password {
    return [YKSUserModel shareInstance].password;
}

+ (NSString *)token {
    return [YKSUserModel shareInstance].token;
}

+ (NSString *)headImageString {
    return [YKSUserModel shareInstance].headImageString;
}

+ (UIImage *)headImage {
    return [YKSUserModel shareInstance].headImage;
}

+ (NSString *)telePhone {
    return [YKSUserModel shareInstance].telePhone;
}

+ (NSString *)deviceToken {
    return [YKSUserModel shareInstance].deviceToken ? [YKSUserModel shareInstance].deviceToken : @"";
}

+ (BOOL)isLogin {
    if ([YKSUserModel telePhone].length > 0) {
        return YES;
    }
    return NO;
}
+ (void)clearData {
    [YKSUserModel shareInstance].userInfo = nil;
    [YKSUserModel shareInstance].userId = nil;
    [YKSUserModel shareInstance].nickName = nil;
    [YKSUserModel shareInstance].token = nil;
    [YKSUserModel shareInstance].userEmail = nil;
    [YKSUserModel shareInstance].password = nil;
    [YKSUserModel shareInstance].headImageString = nil;
}

+ (void)logout {
    [self clearData];
    [UIViewController deleteFile];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kUserInfo];
    [userDefaults synchronize];
}
@end