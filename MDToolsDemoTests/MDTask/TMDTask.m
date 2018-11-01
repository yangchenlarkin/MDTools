//
//  TMDTask.m
//  LToolsDemoTests
//
//  Created by Larkin Yang on 2017/10/9.
//  Copyright © 2017年 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDTasks.h"

@interface TMDTask : XCTestCase

@property (nonatomic, strong) MDTask *task1;
@property (nonatomic, strong) MDTask *task2;
@property (nonatomic, strong) MDTask *task3;
@property (nonatomic, strong) MDTask *task4;
@property (nonatomic, strong) MDTask *task5;

@end

@implementation TMDTask

- (void)setUp {
    [super setUp];
    self.task1 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t1 finish");
            finish(task, YES);
        });
    }];
    
    self.task2 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t2 finish");
            finish(task, YES);
        });
    }];
    
    self.task3 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t3 finish");
            finish(task, YES);
        });
    }];
    
    self.task4 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t4 finish");
            finish(task, YES);
        });
    }];
    
    self.task5 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t5 finish");
            finish(task, YES);
        });
    }];
}

- (void)tearDown {
    self.task1 = nil;
    self.task2 = nil;
    self.task3 = nil;
    self.task4 = nil;
    self.task5 = nil;
    [super tearDown];
}

- (void)testTask {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [self.task1 runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    [tg addTask:self.task1];
    [tg addTask:self.task2];
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskList *tl = [MDTaskList taskList];
    [tl addTask:self.task1];
    [tl addTask:self.task2];
    [tl runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskListInTaskGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskList *tl = [MDTaskList taskList];
    [tl addTask:self.task1];
    [tl addTask:self.task2];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroupWithTasks:tl, self.task3, nil];
    
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskGroupInTaskList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    [tg addTask:self.task1];
    [tg addTask:self.task2];
    
    MDTaskList *tl = [MDTaskList taskListWithTasks:tg, self.task3, nil];
    [tl runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
