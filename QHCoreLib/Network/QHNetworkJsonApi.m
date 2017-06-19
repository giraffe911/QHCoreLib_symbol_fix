//
//  QHNetworkJsonApi.m
//  QHCoreLib
//
//  Created by Tony Tang on 2017/6/8.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "QHNetworkJsonApi.h"
#import "QHNetworkApi+internal.h"

#import "QHMacros.h"
#import "QHUtil.h"


@implementation QHNetworkJsonApi

- (QHNetworkRequest *)buildRequest
{
    QHNetworkRequest *request = [super buildRequest];
    request.resourceType = QHNetworkResourceJSON;
    return request;
}

QH_NETWORK_API_IMPL_INDIRECT(QHNetworkJsonApi, QHNetworkJsonApiResult,
                             QHNetworkHttpApi, QHNetworkHttpApiResult);

@end


@interface QHNetworkJsonApiResult ()

@property (nonatomic, copy, readwrite) NSString *json;

@end

@implementation QHNetworkJsonApiResult

QH_NETWORK_API_RESULT_IMPL_SUPER(QHNetworkJsonApi, QHNetworkJsonApiResult) {
    if (QH_IS_DICTIONARY(response.responseObject)) {
        result.json = response.responseObject;
    }
    else {
        QHCoreLibWarn(@"%@ get json failed: %@\n%@",
                      self,
                      response.responseObject,
                      QHCallStackShort());
        result.json = nil;
    }
}
QH_NETWORK_API_RESULT_IMPL_RETURN;

@end
