//
//  QHCoreLibDefinesTests.m
//  QHCoreLib
//
//  Created by changtang on 2017/5/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "QHDefines.h"

@interface __singleton : NSObject
QH_DEF_SINGLETON
@end

@implementation __singleton
QH_IMP_SINGLETON
@end


@interface QHCoreLibDefinesTests : XCTestCase

@end

@implementation QHCoreLibDefinesTests

- (void)testUnusedVar
{
    int unused_var, unused_var_should_not_warn;
    QH_UNUSED_VAR(unused_var_should_not_warn);
}

- (void)testIS
{
    XCTAssertTrue(QH_IS(@"", NSString), @"@\"\" is NSString");

    NSString *nilStr = nil;
    XCTAssertFalse(QH_IS(nilStr, NSString), @"nil is not NSString");

    NSNumber *number = @0;
    XCTAssertFalse(QH_IS(number, NSString), @"number is not NSString");
}

- (void)testISXXX
{
    XCTAssertTrue(QH_IS_STRING(@""));
    XCTAssertTrue(QH_IS_NUMBER(@0));
    XCTAssertTrue(QH_IS_ARRAY(@[]));
    XCTAssertTrue(QH_IS_DICTIONARY(@{}));
    XCTAssertTrue(QH_IS_SET([NSSet set]));
    XCTAssertTrue(QH_IS_DATA([NSData data]));
}

- (void)testAS
{
    QH_AS(@"", NSString, str);
    XCTAssertNotNil(str, @"@\"\" can be casted to NSString");

    QH_AS(@0, NSString, str2);
    XCTAssertNil(str2, @"number can not be casted to NSString");
}

- (void)testSingleton
{
    __singleton *one = [__singleton sharedInstance];
    __singleton *two = [__singleton sharedInstance];
    XCTAssertEqual(one , two);
}

- (void)testWeakifyStrongifyRetainify
{
    XCTestExpectation *expect = [[XCTestExpectation alloc] initWithDescription:@""];
    __block NSObject *obj = [[NSObject alloc] init];
    @weakify(obj);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(obj);
        XCTAssertNotNil(obj);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        obj = nil;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(obj);
        XCTAssertNil(obj);
        [expect fulfill];
    });

    XCTestExpectation *expect2 = [[XCTestExpectation alloc] initWithDescription:@""];
    @autoreleasepool {
        NSObject *obj2 = [[NSObject alloc] init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @retainify(obj2);
            XCTAssertNotNil(obj2);
            [expect2 fulfill];
        });
    }

    [self waitForExpectations:@[ expect, expect2 ]
                      timeout:0.11
                 enforceOrder:NO];
}

- (void)testPerformSelectorLeakWarning
{
    SEL selector = NSSelectorFromString(@"description");
    // yields a warning
    [self performSelector:selector withObject:nil];

    // no warning
    QH_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN {
        [self performSelector:selector withObject:nil];
    } QH_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_END;
}

@end