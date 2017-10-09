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
    MDTaskGroup *tg = [array lt_taskGroupWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString *obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSLog(@"task: %@", obj);
            [result addObject:[obj stringByAppendingString:[@(idx) stringValue]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(task, YES);
            });
        });
    }];
    
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
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
    MDTaskList *tg = [array lt_taskListWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString *obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSLog(@"task: %@", obj);
            [result addObject:[obj stringByAppendingString:[@(idx) stringValue]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(task, YES);
            });
        });
    }];
    
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
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
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    MDTaskGroup *tg = [dictionary lt_taskGroupWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString * _Nonnull key, NSString *  _Nonnull obj) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            result[key] = [key stringByAppendingString:obj];
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(task, YES);
            });
        });
    }];
    
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        NSLog(@"%@", result);
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
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    MDTaskList *tg = [dictionary lt_taskListWithObjectTask:^(MDTask * _Nonnull task, MDTaskFinish  _Nonnull finish, NSString * _Nonnull key, NSString *  _Nonnull obj, NSUInteger idx) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            result[key] = [key stringByAppendingString:obj];
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(task, YES);
            });
        });
    }];
    
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        NSLog(@"%@", result);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
