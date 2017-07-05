//
//  QHNetworkHttpApi.m
//  QHCoreLib
//
//  Created by Tony Tang on 2017/6/8.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "QHNetworkHttpApi.h"
#import "QHNetworkApi+internal.h"
#import "QHNetworkUtil.h"


NS_ASSUME_NONNULL_BEGIN

@interface QHNetworkHttpApi ()

@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, copy, readwrite) NSDictionary * _Nullable queryDict;
@property (nonatomic, copy, readwrite) NSDictionary * _Nullable bodyDict;

@property (nonatomic, strong, readwrite) NSMutableURLRequest * _Nullable urlRequest;

@end


@implementation QHNetworkHttpApi

- (instancetype)initWithUrl:(NSString *)url
{
    return [self initWithUrl:url queryDict:@{}];
}

- (instancetype)initWithUrl:(NSString *)url
                  queryDict:(NSDictionary *)queryDict
{
    self = [super init];
    if (self) {
        self.method = QHNetWorkHttpMethodGet;
        self.url = url;
        self.queryDict = queryDict;
        self.bodyDict = nil;

        self.urlRequest = nil;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url
                  queryDict:(NSDictionary * _Nullable)queryDict
                   bodyDict:(NSDictionary *)bodyDict
{
    self = [super init];
    if (self) {
        self.method = QHNetWorkHttpMethodPost;
        self.url = url;
        self.queryDict = queryDict;
        self.bodyDict = bodyDict;

        self.urlRequest = nil;
    }
    return self;
}

- (instancetype)initWithUrlRequest:(NSURLRequest *)urlRequest
{
    self = [super init];
    if (self) {
        self.urlRequest = [urlRequest mutableCopy];
    }
    return self;
}

- (QHNetworkRequest *)buildRequest
{
    QHNetworkRequest *request = [[QHNetworkRequest alloc] init];

    if (self.urlRequest) {
        request.urlRequest = self.urlRequest;
    }
    else {
        request.urlRequest = [QHNetworkUtil requestFromMethod:self.method
                                                          url:self.url
                                                    queryDict:self.queryDict
                                                     bodyDict:self.bodyDict];
    }

    request.urlRequest.timeoutInterval = 15.0f;
    request.resourceType = QHNetworkResourceHTTP;

    return request;
}

QH_NETWORK_API_IMPL_DIRECT(QHNetworkHttpApi, QHNetworkHttpApiResult);

@end

@implementation QHNetworkHttpApiResult

QH_NETWORK_API_RESULT_IMPL_SUPER(QHNetworkHttpApi, QHNetworkHttpApiResult) {
    // do nothing
}
QH_NETWORK_API_RESULT_IMPL_RETURN;

@end

NS_ASSUME_NONNULL_END
