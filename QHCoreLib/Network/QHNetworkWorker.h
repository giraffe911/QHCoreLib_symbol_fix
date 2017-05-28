//
//  QHNetworkWorker.h
//  QQHouse
//
//  Created by changtang on 16/12/22.
//
//

#import <Foundation/Foundation.h>

#import "QHNetworkRequest.h"
#import "QHNetworkResponse.h"


@class QHNetworkWorker;

typedef void(^QHNetworkWorkerCompletionHandler)(QHNetworkWorker *worker, QHNetworkResponse *response, NSError *error);

@interface QHNetworkWorker : NSObject

+ (void)cancelAll;

+ (QHNetworkWorker *)workerFromRequest:(QHNetworkRequest *)request;

- (instancetype)init NS_UNAVAILABLE;    // use factory method `workerFromRequest:`

@property (nonatomic, strong, readonly) QHNetworkRequest *request;

- (void)startWithCompletionHandler:(QHNetworkWorkerCompletionHandler)completionHandler;

@property (nonatomic, readonly) BOOL isLoading;

- (void)cancel;

@property (nonatomic, readonly) BOOL isCancelled;

// cost in ms, value is meanless unless finished
@property (nonatomic, readonly) int connectCost;
@property (nonatomic, readonly) int transportCost;
@property (nonatomic, readonly) int requestCost;

@end