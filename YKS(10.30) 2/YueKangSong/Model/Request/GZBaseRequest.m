//
//  GZBaseRequest.m
//  GZTour
//
//  Created by gongliang on 14/12/4.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "GZBaseRequest.h"
#import "YKSUserModel.h"
#import "NSObject+Json.h"
#import <Qiniu/QiniuSDK.h>



//登录
NSString *const kLogin = @"/user/index?op_type=login";
NSString *const kGetVerifyCode = @"/oth/?op_type=gvcode";//get验证码
NSString *const kModifyToken = @"/cdevice?op_type=editidentify";

//首页
NSString *const kSpecialList = @"/site/?op_type=getspeciallist";
NSString *const kSubSpecialList = @"/site/?op_type=getsubspeciallist";
NSString *const kSubSpecialDetail = @"/searchg/?op_type=searchbyspecail";
NSString *const kBannerList = @"/site/index?op_type=getbanner";
NSString *const kSearchBykey = @"/searchg/?op_type=searchbykey";

//购物车
NSString *const kShoppingCartList = @"/shoppingcart/index?op_type=getlist";
NSString *const kAddShoppingCart = @"/shoppingcart/index?op_type=add";
NSString *const kDeleteShoppingCart = @"/shoppingcart/index?op_type=del";
NSString *const kRestartShoppingCart = @"/shoppingcart/index?op_type=restart";//clear cart

//药品
NSString *const kDrugCategoryList = @"/category/index?op_type=categorylist";//药品分类
NSString *const kDrugResult = @"/searchg/?op_type=category";//分类下面的药品

//收藏
NSString *const kCollectList = @"/collect/index?op_type=searchlist";
NSString *const kAddCollect = @"/collect/index?op_type=add";
NSString *const kDeleteCollect = @"collect/index?op_type=del";

//收货地址
NSString *const kAddressList = @"/express/index?op_type=getaddresslist"; //    /api.yuekangsong.com_1.0/index.php
NSString *const kAddAddress = @"/express/index?op_type=addaddress";
NSString *const kEditAddress = @"/express/index?op_type=editaddress";
NSString *const kAreaCode = @"/express/index?op_type=searcharea";//获取省市县 地区编码
NSString *const kDeleteAddress = @"/express/index?op_type=deladdress";
NSString *const kExpressInfo = @"/express/index?op_type=getExpressInfo";//查询快递信息 express_orderid=快递单号

//订单
/**
 *  op_type=searchbyid根据id查询订单
	op_type=searchbystatus根据status查询订单status是空查询所有
	op_type=searchbydid根据药店id 查询订单 也可以把oid 传入 这个时候查询这个药店下的指定订单号
 
 */
NSString *const kSearchOrderById = @"/corder/index?op_type=searchbyid";
NSString *const kSearchOrderByStatus = @"/corder/index?op_type=searchbystatus";
NSString *const kSearchOrderByDrugId = @"/corder/index?op_type=searchbydid";
NSString *const kSubmitOrder = @"/corder/index?op_type=submit";//commit

//优惠劵
NSString *const kCouponList = @"/couponid/index?op_type=searchmyself";//获得优惠卷列表

NSString *const kConvertCoupon = @"/couponid/index?op_type=exchange";//兑换优惠卷

//其它
NSString *const kFeedback = @"/feedback/index?op_type=feedback";//反馈
NSString *const kQiniuToken = @"/cqiniu?op_type=CreateUptoken";
NSString *const kGetMyInfo = @"/chealth?op_type=gethinfo";
NSString *const kEditMyInfo = @"/chealth?op_type=edithinfo";
NSString *const kBaseInfo = @"/company/index?op_type=baseinfo";//免费起送假，运费等
NSString *const kGetMsg = @"/cmsg?op_type=getmsg";
NSString *const kLocationReport = @"/locationreport?op_type=report";


/**
 *  城市列表url
 */
NSString *const cityList=@"/cities?op_type=activecities";

//根据步数领取对应优惠券

NSString *const healthwalkexchange=@"/couponid/index?op_type=healthwalkexchange";

//获取某个用户当天根据步数兑换的优惠券

NSString *const getwalkcouponstoday=@"/couponid/index?op_type=getwalkcouponstoday";

//判断支付渠道
NSString *const getpaytype =@"/corder/index?op_type=getpaytype";

//获取药店ID
NSString *const kDrugStoreid = @"/corder/index?op_type=countNext5shop";

@implementation GZBaseRequest

//获取后台版本
+(void)getBackgroundVersionAndcallBack:(void (^)(id responseObject, NSError *error ))callback{

    [[GZHTTPClient shareClient]GET:@"/Cversion/index?op_type=iosversion" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        callback(responseObject,nil);
 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
}

//邀请码
+(void)getYQMAndcallBack:(void (^)(id responseObject, NSError *error ))callback{
    [[GZHTTPClient shareClient]GET:@"/user/index?op_type=getinvite" parameters:@{@"mobilephone":[YKSUserModel shareInstance].telePhone} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
}
//新增用户推广信息接口:
+(void)getYQMPromotephone:(NSString *)phone andcode:(NSString *)code AndcallBack:(void (^)(id responseObject, NSError *error ))callback{
    [[GZHTTPClient shareClient] GET:@"/user/index?op_type=writeinvite" parameters:@{@"mobilephone":phone,@"invitenum":code} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
}

//.获取徽章信息
+(void)getYQMhuizhangphone:(NSString *)phone AndcallBack:(void (^)(id responseObject, NSError *error ))callback{
    [[GZHTTPClient shareClient] GET:@"/user/index?op_type=detailed" parameters:@{@"mobilephone":phone} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
    
    
}
//领取优惠券
+(void)lingquYQMAndcallBack:(void (^)(id responseObject, NSError *error ))callback{
    [[GZHTTPClient shareClient] GET:@"/user/index?op_type=badge" parameters:@{@"mobilephone":[YKSUserModel shareInstance].telePhone} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject,nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
    
    
    
    
}


+ (NSString *)jointPhone:(NSString *)apiPath {
    return [apiPath stringByAppendingFormat:@"&mobilephone=%@", [YKSUserModel telePhone]];
}

+ (NSDictionary *)addLatAndLng:(NSDictionary *)params {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (params) {
        [dic addEntriesFromDictionary:params];
    }
    if ([YKSUserModel shareInstance].lat > 0) {
        dic[@"lat"] = @([YKSUserModel shareInstance].lat);
        dic[@"lng"] = @([YKSUserModel shareInstance].lng);
    }
    return dic.count > 0 ? dic : nil;
}

#pragma mark Public
/************************* 登录 *************************/
//登录 password 是 md5加密的
+ (NSURLSessionDataTask *)loginByMobilephone:(NSString *)phone
                                    password:(NSString *)password
                                    invitecode:(NSString *)invitecode                                     callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": phone,
                             @"upwd": [YKSTools md5:password],
                             @"token": [YKSUserModel deviceToken],
                             @"invitecode":invitecode,
                             @"tags": ClientKey};
    NSLog(@"登录上传token params = %@", params);
    return [[GZHTTPClient shareClient] POST:kLogin
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

//获取验证码
+ (NSURLSessionDataTask *)verifyCodeByMobilephone:(NSString *)phone
                                         callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": phone};
    return [[GZHTTPClient shareClient] GET:kGetVerifyCode
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

+ (NSURLSessionDataTask *)modifyToken:(NSString *)token
                             callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"token": [YKSUserModel deviceToken],
                             @"tags": ClientKey};
    return [[GZHTTPClient shareClient] GET:[self jointPhone:kModifyToken]
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}


/************************* 首页 *************************/
//首页列表 http://123.56.89.98:8081/site/?op_type=getspeciallist
+ (NSURLSessionDataTask *)specialListCallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kSpecialList
                                parameters:[self addLatAndLng:nil]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//子专题列表 http://123.56.89.98:8081/site/?op_type=getsubspeciallist&special_id=18
+ (NSURLSessionDataTask *)subSpecialListByspecialId:(NSString *)specialId
                                           callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kSubSpecialList
                                parameters:[self addLatAndLng:@{@"special_id": specialId}]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//子专题内容 http://123.56.89.98:8081/searchg/?op_type=searchbyspecail&special_id=24
+ (NSURLSessionDataTask *)subSpecialDetailBy:(NSString *)specialId
                                    callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:[self jointPhone:kSubSpecialDetail]
                                parameters:[self addLatAndLng:@{@"special_id": specialId}]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//首页轮播图banner
+ (NSURLSessionDataTask *)bannerListByMobilephone:(NSString *)phone
                                         callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": @""};
    if (phone) {
        params = @{@"mobilephone": phone};
    }
    return [[GZHTTPClient shareClient] GET:kBannerList
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSArray *a =responseObject[@"data"];
                                       if (a.count==0) {
                                           return ;
                                       }
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//通过key搜索商品 http://123.56.89.98:8081/searchg/?op_type=searchbykey&searchkey=%E5%A4%A9%E5%A4%A9
+ (NSURLSessionDataTask *)searchByKey:(NSString *)key
                                 page:(NSInteger)page
                             callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient]  GET:[self jointPhone:kSearchBykey]
                                 parameters:[self addLatAndLng:@{@"searchkey": key,
                                                                 @"page": @(page)}]
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
    
}

/************************* 药品 *************************/
//药品分类列表 http://123.56.89.98:8081/category/index?op_type=categorylist
+ (NSURLSessionDataTask *)drugCategoryListCallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient]  GET:kDrugCategoryList
                                 parameters:[self addLatAndLng:nil]
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

//根据药品该类获得 http://123.56.89.98:8081/searchg/?op_type=category&categoryid=3
+ (NSURLSessionDataTask *)drugListByCategoryId:(NSString *)categoryId
                                      callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kDrugResult
                                parameters:@{@"categoryid": categoryId,
                                             @"mobilephone": [YKSUserModel telePhone],
                                             @"lat": @([YKSUserModel shareInstance].lat),
                                             @"lng": @([YKSUserModel shareInstance].lng)}
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/************************* 购物车 *************************/
+ (NSURLSessionDataTask *)shoppingcartListCallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kShoppingCartList
                                parameters:[self addLatAndLng:@{@"mobilephone": [YKSUserModel telePhone]}]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/**
 *  加入到购物车
 *
 *  @param gcontrast 商品对照
 上传上来的是一个json数组
 [
 {
 gid:"1' 商品的id
 gcount:1 购买商品数量
 gtag：商品的标识 0非处方 1处方 药
 banners://商品轮播图片 逗号分割
 gtitle:商品名称
 gprice:价格
 gpricemart:市场价格
 glogo:图片logo
 gdec:描述
 purchase://限购数量 默认0
 gstandard:"逗号分割"，
 vendor：//厂商名称
 iscollect://是否被收藏 1收藏 0未收藏
 gmanual://说明书}
 ]
 *  @param gids      药品id 多个逗号分割
 *  @param callback  回调
 *
 *  @return
 */
+ (NSURLSessionDataTask *)addToShoppingcartParams:(NSArray *)gcontrast
                                             gids:(NSString *)gids
                                         callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"gcontrast": [gcontrast objectToJsonString],
                             @"gids": gids};
    return [[GZHTTPClient shareClient] POST:[self jointPhone:kAddShoppingCart]
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (NSURLSessionDataTask *)deleteShoppingCartBygids:(NSString *)gids
                                          callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"gids": gids};
    return [[GZHTTPClient shareClient] POST:[self jointPhone:kDeleteShoppingCart]
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}


+ (NSURLSessionDataTask *)restartShoppingCartBygids:(NSString *)gids
                                           callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] POST:[self jointPhone:kRestartShoppingCart]
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}


/************************* 收藏 *************************/
/**
 *  收藏列表
 *  @param page     第几页 每页10条
 * http://123.56.89.98:8081/collect/index?op_type=searchlist&mobilephone=18610316343&page=0
 */
+ (NSURLSessionDataTask *)collectListByPage:(NSInteger)page andlat:(NSString *)lat andlng:(NSString *)lng callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"lat":lat,
                             @"lng":lng,
                             @"page": @(page)};
    return [[GZHTTPClient shareClient] GET:kCollectList
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

+ (NSURLSessionDataTask *)addCollectByGid:(NSString *)gid
                                 callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"gids": gid};
    return [[GZHTTPClient shareClient] GET:kAddCollect
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/**
 *  删除收藏
 *
 *  @param gids     多个gid 用逗号分开
 *  @param callback
 *
 *  @return
 */
+ (NSURLSessionDataTask *)deleteCollectByGid:(NSString *)gids
                                    callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"gids": gids};
    return [[GZHTTPClient shareClient] GET:kDeleteCollect
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/************************* 收货地址 *************************/
// http://123.56.89.98:8081/express/index?op_type=getaddresslist&mobilephone=18610316343
+ (NSURLSessionDataTask *)areaInfoCallBack:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kAreaCode
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

+ (NSURLSessionDataTask *)addressListCallback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone]};
    return [[GZHTTPClient shareClient] GET:kAddressList
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//增加收货地址
+ (NSURLSessionDataTask *)addAddressExpressArea:(NSString *)expressArea
                                      community:(NSString *)community
                                communityLatLng:(NSString *)communityLatLng
                                  detailAddress:(NSString *)detailAddress
                                       contacts:(NSString *)contact
                                      telePhone:(NSString *)telePhone
                                       cityName:(NSString *)cityName callback:(void (^)(id, NSError *))callback
{
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"express_area": expressArea,
                             @"community": community,
                             @"community_lat_lng": communityLatLng,
                             @"express_detail_address": detailAddress,
                             @"express_username": contact,
                             @"express_mobilephone": telePhone,
                             @"city_name":cityName
                             };
    
    
    return [[GZHTTPClient shareClient] GET:kAddAddress
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                       
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//编辑收货地址
+ (NSURLSessionDataTask *)editAddressById:(NSString *)addressId
                              expressArea:(NSString *)expressArea
                                community:(NSString *)community
                          communityLatLng:(NSString *)communityLatLng
                            detailAddress:(NSString *)detailAddress
                                 contacts:(NSString *)contact
                                telePhone:(NSString *)telePhone
                                 cityName:(NSString *)cityName
                                 callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"addressid": addressId,
                             @"express_area": expressArea,
                             @"community": community,
                             @"community_lat_lng": communityLatLng,
                             @"express_detail_address": detailAddress,
                             @"express_username": contact,
                             @"express_mobilephone": telePhone,
                             @"city_name":cityName
                             };
    return [[GZHTTPClient shareClient] GET:kEditAddress
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//删除收货地址
+ (NSURLSessionDataTask *)deleteAddressById:(NSString *)addressId
                                   callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"addressid": addressId};
    return [[GZHTTPClient shareClient] GET:kDeleteAddress
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//快递单号查询
+ (NSURLSessionDataTask *)expressInfo:(NSString *)expressId
                             callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"express_orderid": expressId};
    return [[GZHTTPClient shareClient] GET:kExpressInfo
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
    
}

/************************* 订单 *************************/
//NSString *const kSubmitOrder = @"/corder/index?op_type=submit";
+ (NSURLSessionDataTask *)searchOrderByOrderId:(NSString *)orderId
                                          page:(NSInteger)page
                                      callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"oid": orderId,
                             @"page": @(page)};
    return [[GZHTTPClient shareClient] GET:kSearchOrderById
                                parameters:[self addLatAndLng:params]
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

+ (NSURLSessionDataTask *)searchOrderByOrderStatus:(NSInteger)status
                                              page:(NSInteger)page
                                          callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"status": @(status),
                             @"page": @(page)};
    return [[GZHTTPClient shareClient] GET:kSearchOrderByStatus
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
    
}

+ (NSURLSessionDataTask *)searchOrderByDrugId:(NSString *)did
                                         page:(NSInteger)page
                                     callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"did": did,
                             @"page": @(page)};
    return [[GZHTTPClient shareClient] GET:kSearchOrderByDrugId
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
    
}

/**
 *
 *  @param gcontrast 商品对照
 上传上来的是一个json数组
 [
 {
 gid:"1'.商品的id
 gcount:1购买商品数量
 gtag：商品的标识 0非处方 1处方 药
 }
 ]
 */
+ (NSURLSessionDataTask *)submitOrderContrast:(NSArray *)gcontrast
                                     couponid:(NSString *)couponId
                                    addressId:(NSString *)addressId
                                       images:(NSArray *)images
                                       charge:(NSDictionary *)charge
                                     pay_type:(NSString *)pay_type
                                     callback:(void (^)(id responseObject, NSError *error))callback {
    NSMutableDictionary *params = [@{@"gcontrast": [gcontrast objectToJsonString],
                                     @"express_id": addressId,
                                     @"charge":[charge objectToJsonString],
                                     @"pay_type":pay_type
                                     } mutableCopy
                                   ];
    //看看这个请求字典,没转json之前的样子
    NSLog(@"---- ccccc------%@",@{@"gcontrast":gcontrast});
    if (couponId) {//这是什么,有优惠信息
        params[@"couponid"] = couponId;
        NSLog(@"---- couponid------%@",couponId);
        //这里有id,可是不一定有优惠券的价格,但是优惠券展示请求里面一定有价格
    }
    
    //post,查看服务器这里购物车的数据,有么,库存呢
    if (!images || images.count == 0) {
        return [[GZHTTPClient shareClient] POST:[self jointPhone:kSubmitOrder]
                                     parameters:params
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            callback(responseObject, nil);
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            callback(nil, error);
                                        }];
    } else {
        [self qiniuTokeCallback:^(id responseObject, NSError *error) {
            if (ServerSuccess(responseObject)) {
                NSString *token = responseObject[@"data"][@"token"];
                NSString *imageBaseURL = responseObject[@"data"][@"imagebaseurl"];
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                __block NSMutableArray *imageIds = [NSMutableArray array];
                for (UIImage *image in images) {
                    NSData *data = UIImageJPEGRepresentation(image, 0.8);
                    [upManager putData:data
                                   key:nil
                                 token:token
                              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                  NSString *qiniuURLString = [imageBaseURL stringByAppendingString:resp[@"key"]];
                                  [imageIds addObject:qiniuURLString];
                                  if (imageIds.count == images.count) {
                                      params[@"postimgfile"] = imageIds;
                                      [[GZHTTPClient shareClient] POST:[self jointPhone:kSubmitOrder]
                                                            parameters:params
                                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                   callback(responseObject, nil);
                                                               }
                                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                   callback(nil, error);
                                                               }];
                                  }
                              } option:nil];
                }
            } else {
                callback(nil, error);
            }
        }];
        
        return nil;
    }
}

/************************* 优惠劵 *************************/
// http://123.56.89.98:8081/couponid/index?op_type=searchmyself&mobilephone=18610316343&page=1
+ (NSURLSessionDataTask *)couponList:(NSInteger)page
                            callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"page": @(page)};
    //get到优惠信息
    //返回一个什么请求的总共结果
    return [[GZHTTPClient shareClient] GET:kCouponList
                                parameters:params
            //成功
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSLog(@"---- responseObject 优惠券成功,看里面的价格------%@",responseObject);
                                       //这里里面有一个faceprice = "5.00";
                                       //id = 31;
                                       //status = 1;
                                       //我们跟踪,看它是如何找到优惠券信息价格的
                                       NSLog(@"----couponlist ------%@",responseObject[@"data"]);
                                       NSDictionary *datadict = responseObject[@"data"];
                                       NSLog(@"---- datadict ------%@",datadict);
                                       
#warning 这里只要找到这个优惠券值,储存,然后那里再减去一个这样的值就ok了
                                       
                                       NSLog(@"----faceprice ------%@",datadict[@"faceprice"]);
                                       // NSObject *faceprice = datadict[@"faceprice"];
                                       
                                       
                                       
                                       callback(responseObject, nil);
                                   }
            //                  失败
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

// http://123.56.89.98:8081/couponid/index?op_type=exchange&mobilephone=18610316343&exchangecode=child
+ (NSURLSessionDataTask *)convertCouponBByCode:(NSString *)code
                                      callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"mobilephone": [YKSUserModel telePhone],
                             @"exchangecode": code};
    return [[GZHTTPClient shareClient] GET:kConvertCoupon
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/************************* 其它 *************************/
//问题反馈
+ (NSURLSessionDataTask *)feedbackByContent:(NSString *)content
                                   callback:(void (^)(id responseObject, NSError *error))callback {
    NSDictionary *params = @{@"feedbackcon": content};
    return [[GZHTTPClient shareClient] POST:[self jointPhone:kFeedback]
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

//http://123.56.89.98:8081/cqiniu?op_type=CreateUptoken
+ (NSURLSessionDataTask *)qiniuTokeCallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kQiniuToken
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

// http://123.56.89.98:8081/chealth?op_type=gethinfo&mobilephone=18610316343
+ (NSURLSessionDataTask *)myInfocallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:[self jointPhone:kGetMyInfo]
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//
+ (NSURLSessionDataTask *)editMyInfoAge:(NSInteger)age
                                    sex:(NSInteger)sex
                                   name:(NSString *)name
                               callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:[self jointPhone:kEditMyInfo]
                                parameters:@{@"age": @(age),
                                             @"sex": @(sex),
                                             @"userName": name}
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

/*
 {
 code：200
 msg：
 data：{
 distribution_imgurl:配送地区的 图片地址
 distribution_dec:配送地区的描述
 }
 }
 */
+ (NSURLSessionDataTask *)baseInfocallback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient] GET:kBaseInfo
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

+ (NSURLSessionDataTask *)msgListByPage:(NSInteger)page
                               callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient]  GET:[self jointPhone:kGetMsg]
                                 parameters:@{@"page": @(page)}
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

+ (NSURLSessionDataTask *)locationUploadLat:(CGFloat)lat
                                        lng:(CGFloat)lng
                                   callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient]  GET:[self jointPhone:kLocationReport]
                                 parameters:@{@"lat": @(lat),
                                              @"lng": @(lng)}
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        
                                        callback(responseObject, nil);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

/**
 *  网络请求城市数据
 *
 */
+(NSURLSessionDataTask *)cityNameLictBack:(void (^)(id, NSError *))callback
{
    return [[GZHTTPClient shareClient] GET:cityList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        callback(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        callback(nil,error);
        
    }];
}

//获取某个用户当天根据步数兑换的优惠券

+ (NSURLSessionDataTask *)getwalkcouponstoday:(NSString *)telePhone andMac:(NSString *)mac
                                     callback:(void (^)(id responseObject, NSError *error))callback {
    
    NSDictionary *params = @{@"phone": telePhone,@"mac":mac};
    
    
    return [[GZHTTPClient shareClient] GET:getwalkcouponstoday
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}


//根据步数领取对应优惠券

+ (NSURLSessionDataTask *)healthwalkexchange:(NSString *)telePhone exchangecode:(NSString *)exchangecode
                                    callback:(void (^)(id responseObject, NSError *error))callback {
    
    NSDictionary *params = @{@"phone": telePhone,@"exchangecode":exchangecode};
    
    
    return [[GZHTTPClient shareClient] GET:healthwalkexchange
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       callback(responseObject, nil);
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       callback(nil, error);
                                   }];
}

//  判断支付渠道
+(NSURLSessionDataTask *)getpaytype:(void(^)(id responseObject,NSError *error))callback
{
     return [[GZHTTPClient shareClient] GET:getpaytype parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        callback(responseObject,nil);
    }
      failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         callback(nil, error);
    }];
}
//获得药店ID
+ (NSURLSessionDataTask *)DrugStoreUploadLat:(CGFloat)lat
                                         lng:(CGFloat)lng
                                    callback:(void (^)(id responseObject, NSError *error))callback {
    return [[GZHTTPClient shareClient]  GET:[self jointPhone:kDrugStoreid]
                                 parameters:@{@"lat": @(lat),
                                              @"lng": @(lng)}
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        
                                        callback(responseObject, nil);
                                        
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        callback(nil, error);
                                    }];
}

@end
