//
//  QHNetworkRequest.h
//  QQHouse
//
//  Created by changtang on 16/12/22.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, QHNetworkRequestPriority) {
    QHNetworkRequestPriorityDeafult = 0,
    QHNetworkRequestPriorityHigh,
    QHNetworkRequestPriorityLow,
};

typedef NS_ENUM(NSUInteger, QHNetworkResourceType) {
    QHNetworkResourceHTTP,
    QHNetworkResourceJSON,
    QHNetworkResourceImage,
};

@interface QHNetworkRequest : NSObject

@property (nonatomic, strong) NSMutableURLRequest *urlRequest;          // default nil

@property (nonatomic, assign) QHNetworkRequestPriority priority;        // default QHNetworkRequestPriorityDeafult

@property (nonatomic, assign) QHNetworkResourceType resourceType;       // default QHNetworkResourceHTTP

@end