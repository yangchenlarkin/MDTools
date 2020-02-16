//
//  TMDTaskRetry.m
//  LToolsDemoTests
//
//  Created by Larkin Yang on 2017/10/9.
//  Copyright © 2017年 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTasks.h"

@interface TMDTaskRetry : XCTestCase

@end

@implementation TMDTaskRetry

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRetryTaskFail {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTask *task1 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"task1");
        finish(task, MDTaskDefaultError, @"t1 result");
    }
                   cancelBlock:NULL
                 taskFailBlock:^(MDTask *task, NSUInteger tryCount, void (^retry)(BOOL retry)) {
                     if (tryCount > 3) {
                         retry(NO);
                     } else {
                         retry(YES);
                     }
                 }];
    
    MDTask *task2 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"task2");
        finish(task, nil, @"t2 result");
    }
                     cancelBlock:^(MDTask *task) {
        NSLog(@"task2 canceled");
    }];
    
    [[MDTaskList taskListWithTasks:task1, task2, nil] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        if (error) {
            NSLog(@"fail: %@", error);
            NSLog(@"task1 result is: %@", resultProxy(task1.taskId));
            NSLog(@"task2 result is: %@", resultProxy(task2.taskId));
        } else {
            NSLog(@"success");
            NSLog(@"task1 result is: %@", resultProxy(task1.taskId));
            NSLog(@"task2 result is: %@", resultProxy(task2.taskId));
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testRetryTaskSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    static int count = 3;
    MDTask *task1 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"task1");
        finish(task, --count == 0 ? nil : MDTaskDefaultError, @"t1 result");
    }
                   cancelBlock:NULL
                 taskFailBlock:^(MDTask *task, NSUInteger tryCount, void (^retry)(BOOL retry)) {
                     if (tryCount > 5) {
                         retry(NO);
                     } else {
                         retry(YES);
                     }
                 }];
    
    MDTask *task2 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"task2");
        finish(task, nil, @"t2 result");
    }
                     cancelBlock:^(MDTask *task) {
        NSLog(@"task2 canceled");
    }];
    
    [[MDTaskList taskListWithTasks:task1, task2, nil] runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        if (error) {
            NSLog(@"fail: %@", error);
            NSLog(@"task1 result is: %@", resultProxy(task1.taskId));
            NSLog(@"task2 result is: %@", resultProxy(task2.taskId));
        } else {
            NSLog(@"success");
            NSLog(@"task1 result is: %@", resultProxy(task1.taskId));
            NSLog(@"task2 result is: %@", resultProxy(task2.taskId));
        }
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
