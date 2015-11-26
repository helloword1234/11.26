//
//  GZHTTPClient.m
//  GZTour
//
//  Created by gongliang on 14/12/2.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "GZHTTPClient.h"

@implementation GZHTTPClient

#pragma mark - private

+ (instancetype)shareClient {
    static GZHTTPClient *_shareClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _shareClient =  [[GZHTTPClient alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        _shareClient.responseSerializer = (AFHTTPResponseSerializer *)[AFJSONResponseSerializer serializer];
        _shareClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", nil];
        [_shareClient.requestSerializer setTimeoutInterval:kDefaultTimeOutInterval];
    });
    return _shareClient;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return  [super GET:URLString
            parameters:parameters
               success:success
               failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    return [super POST:URLString
            parameters:parameters
               success:success
               failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [super POST:URLString
            parameters:parameters
constructingBodyWithBlock:block
               success:success
               failure:failure];

}




@end
