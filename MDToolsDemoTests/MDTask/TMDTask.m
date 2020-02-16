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
    self.task1 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"running t1 with input: %@", inputProxy(nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t1 finish");
            finish(task, nil, @"t1 result");
        });
    }
                   withTaskId:@"1"];
    self.task1.resultGenerator = ^id(id originResult) {
        return [originResult stringByAppendingString:@"(add sufix)"];
    };
    
    self.task2 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"running t2 with input: %@", inputProxy(nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t2 finish");
            finish(task, nil, @"t2 result");
        });
    }
                   withTaskId:@"2"];
    self.task2.resultGenerator = ^id(id originResult) {
        return [originResult stringByAppendingString:@"(add sufix)"];
    };
    
    self.task3 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"running t3 with input: %@", inputProxy(nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t3 finish");
            finish(task, nil, @"t3 result");
        });
    }
                   withTaskId:@"3"];
    self.task3.resultGenerator = ^id(id originResult) {
        return [originResult stringByAppendingString:@"(add sufix)"];
    };
    
    self.task4 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"running t4 with input: %@", inputProxy(nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t4 finish");
            finish(task, nil, @"t4 result");
        });
    }
                   withTaskId:@"4"];
    self.task4.resultGenerator = ^id(id originResult) {
        return [originResult stringByAppendingString:@"(add sufix)"];
    };
    
    self.task5 = [MDTask task:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
        NSLog(@"running t5 with input: %@", inputProxy(nil));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"t5 finish");
            finish(task, nil, @"t5 result");
        });
    }
                   withTaskId:@"5"];
    self.task5.resultGenerator = ^id(id originResult) {
        return [originResult stringByAppendingString:@"(add sufix)"];
    };
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
    [self.task1 runWithInput:@"origin input" finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2.taskId));
        NSLog(@"task3 result is: %@", resultProxy(self.task3.taskId));
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    [tg addTask:self.task1];
    [tg addTask:self.task2];
    [tg runWithInput:@"origin input"
        finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2.taskId));
        NSLog(@"task3 result is: %@", resultProxy(self.task3.taskId));
        NSLog(@"task grop result is: %@", resultProxy(nil));
        [expectation fulfill];
    }];
    tg.resultGenerator = ^id(id originResult) {
        return [NSString stringWithFormat:@"%@(add sufix)", originResult];
    };
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

- (void)testTaskList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskList *tl = [MDTaskList taskList];
    [tl addTask:self.task1];
    [tl addTask:self.task2];
    [tl addTask:self.task3];
    [tl addTask:self.task4];
    [tl addTask:self.task5];
    [tl runWithInput:@"origin input"
        finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2.taskId));
        NSLog(@"task3 result is: %@", resultProxy(self.task3.taskId));
        NSLog(@"task list result is: %@", resultProxy(nil));
        [expectation fulfill];
    }];
    tl.resultGenerator = ^id(id originResult) {
        return [NSString stringWithFormat:@"%@(add sufix)", originResult];
    };
    [self waitForExpectationsWithTimeout:6 handler:nil];
}

- (void)testTaskListInTaskGroup {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskList *tl = [MDTaskList taskList];
    [tl addTask:self.task1];
    [tl addTask:self.task2];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroupWithTasks:tl, self.task3, nil];
    
    [tg runWithInput:@"origin input"
        finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2.taskId));
        NSLog(@"task3 result is: %@", resultProxy(self.task3.taskId));
        NSLog(@"task group result is: %@", resultProxy(nil));
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3000 handler:nil];
}

- (void)testTaskGroupInTaskList {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    [tg addTask:self.task1];
    [tg addTask:self.task2];
    
    MDTaskList *tl = [MDTaskList taskListWithTasks:tg, self.task3, nil];
    [tl runWithInput:@"origin input"
        finishResult:^(__kindof MDTask *task, NSError *error, MDTaskResultProxy resultProxy) {
        NSLog(@"task1 result is: %@", resultProxy(self.task1.taskId));
        NSLog(@"task2 result is: %@", resultProxy(self.task2.taskId));
        NSLog(@"task3 result is: %@", resultProxy(self.task3.taskId));
        NSLog(@"task list result is: %@", resultProxy(nil));
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
