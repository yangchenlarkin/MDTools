//
//  TMDTaskCancel.m
//  LToolsDemoTests
//
//  Created by Larkin Yang on 2017/10/9.
//  Copyright © 2017年 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTasks.h"

@interface TMDTaskCancel : XCTestCase

@property (nonatomic, strong) MDTask *task1_succes_2sec;
@property (nonatomic, strong) MDTask *task2_fail_1sec;

@end

@implementation TMDTaskCancel

- (void)setUp {
    [super setUp];
    self.task1_succes_2sec = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t1 success");
            finish(task, nil, @"t1 result");
        });
    }
                             cancelBlock:^(MDTask *task) {
                                 NSLog(@"t1 canceled");
                             }];
    
    self.task2_fail_1sec = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t2 fail");
            finish(task, MDTaskDefaultError, @"t2 failed");
        });
    }];
}

- (void)tearDown {
    self.task1_succes_2sec = nil;
    self.task2_fail_1sec = nil;
    [super tearDown];
}

- (void)testCancelGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    
    [tg addTask:self.task2_fail_1sec];
    [tg addTask:self.task1_succes_2sec];
    
    [tg runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1_succes_2sec.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2_fail_1sec.taskId));
        if (error) {
            NSLog(@"failed: %@", error);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testCancelList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    MDTaskList *tl = [MDTaskList taskList];
    
    [tl addTask:self.task2_fail_1sec];
    [tl addTask:self.task1_succes_2sec];
    
    [tl runWithFinishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1_succes_2sec.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2_fail_1sec.taskId));
        if (error) {
            NSLog(@"failed: %@", error);
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
