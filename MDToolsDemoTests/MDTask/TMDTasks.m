//
//  TMDTasks.m
//  LToolsDemoTests
//
//  Created by Larkin Yang on 2017/10/9.
//  Copyright © 2017年 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTasks.h"

@interface TMDTasks : XCTestCase

@end

@implementation TMDTasks

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArrayGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSArray *array = @[
                       @"0",
                       @"1",
                       @"2",
                       @"3",
                       @"4",
                       @"5",
                       @"6",
                       @"7",
                       @"8",
                       @"9",
                       ];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    MDTaskGroup *tg = [array md_taskGroupWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString *obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            finish(task, nil, [obj stringByAppendingString:[@(idx) stringValue]]);
        });
    }
                                         taskIdForIndex:^NSString * _Nullable(id  _Nonnull obj, NSUInteger idx) {
        return [@(idx) stringValue];
    }];
    
    [tg runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        for (NSUInteger i = 0; i < array.count; i++) {
            [result addObject:resultProxy([@(i) stringValue])];
        }
        NSLog(@"%@", result);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testArrayList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSArray *array = @[
                       @"0",
                       @"1",
                       @"2",
                       @"3",
                       @"4",
                       @"5",
                       @"6",
                       @"7",
                       @"8",
                       @"9",
                       ];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    MDTaskList *tg = [array md_taskListWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString *obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSLog(@"task: %@", obj);
            [result addObject:[obj stringByAppendingString:[@(idx) stringValue]]];
            finish(task, nil, nil);
        });
    }];
    
    [tg runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"%@", result);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testDictionaryGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSDictionary *dictionary = @{
                                 @"0": @"_0",
                                 @"1": @"_1",
                                 @"2": @"_2",
                                 @"3": @"_3",
                                 @"4": @"_4",
                                 @"5": @"_5",
                                 @"6": @"_6",
                                 @"7": @"_7",
                                 @"8": @"_8",
                                 @"9": @"_9",
                                 };
    
    [[dictionary md_taskGroupWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString * _Nonnull key, NSString *  _Nonnull obj) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            finish(task, nil, [key stringByAppendingString:obj]);
        });
    }
                               taskIdForKey:^NSString * _Nullable(id  _Nonnull key, id  _Nonnull obj) {
        return key;
    }] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        for (id key in dictionary) {
            NSLog(@"{result for key [%@] is [%@]", key, resultProxy(key));
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testDictionaryList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSDictionary *dictionary = @{
                                 @"0": @"_0",
                                 @"1": @"_1",
                                 @"2": @"_2",
                                 @"3": @"_3",
                                 @"4": @"_4",
                                 @"5": @"_5",
                                 @"6": @"_6",
                                 @"7": @"_7",
                                 @"8": @"_8",
                                 @"9": @"_9",
                                 };
    
    [[dictionary md_taskListWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString * _Nonnull key, NSString *  _Nonnull obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            finish(task, nil, [key stringByAppendingString:obj]);
        });
    }
                              taskIdForKey:^NSString * _Nullable(id  _Nonnull key, id  _Nonnull obj) {
        return key;
    }] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        for (id key in dictionary) {
            NSLog(@"{result for key [%@] is [%@]", key, resultProxy(key));
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testSetGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSSet *set = [NSSet setWithObjects:
                  @"0",
                  @"1",
                  @"2",
                  @"3",
                  @"4",
                  @"5",
                  @"6",
                  @"7",
                  @"8",
                  @"9", nil];
    
    [[set md_taskGroupWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString * _Nonnull obj) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            finish(task, nil, [obj stringByAppendingString:@"_hello"]);
        });
    }
                     taskIdForObject:^NSString * _Nullable(id  _Nonnull obj) {
        return obj;
    }] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        for (id obj in set) {
            NSLog(@"result for obj [%@] is [%@]", obj, resultProxy(obj));
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testSetList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    NSSet *set = [NSSet setWithObjects:
                  @"0",
                  @"1",
                  @"2",
                  @"3",
                  @"4",
                  @"5",
                  @"6",
                  @"7",
                  @"8",
                  @"9", nil];
    
    [[set md_taskListWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, id  _Nonnull obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            finish(task, nil, [obj stringByAppendingString:[@(idx) stringValue]]);
        });
    }
                 taskIdForIdxObject:^NSString * _Nullable(id  _Nonnull obj, NSUInteger idx) {
        return obj;
    }] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        for (id obj in set) {
            NSLog(@"result for obj [%@] is [%@]", obj, resultProxy(obj));
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
