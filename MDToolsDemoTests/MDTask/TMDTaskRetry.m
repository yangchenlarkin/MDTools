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

- (void)testRetryTask {
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    __block BOOL result = YES;
    
    MDTask *task1 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        NSLog(@"task1");
        result = !result;
        finish(task, result);
    }
                   cancelBlock:NULL
                 taskFailBlock:^(MDTask *task, NSUInteger tryCount, void (^retry)(BOOL retry)) {
                     if (tryCount > 1) {
                         retry(NO);
                     } else {
                         retry(YES);
                     }
                 }];
    
    MDTask *task2 = [MDTask task:^(MDTask *task, MDTaskFinish finish) {
        NSLog(@"task2");
        finish(task, YES);
    }];
    
    MDTaskGroup *tg = [MDTaskGroup taskGroup];
    [tg addTask:task1];
    [tg addTask:task2];
    [tg runWithFinish:^(__kindof MDTask *task, BOOL succeed) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3 handler:nil];
}

@end
