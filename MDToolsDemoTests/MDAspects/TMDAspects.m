//
//  TMDAspects.m
//  MDToolsDemoTests
//
//  Created by Larkin Yang on 2018/12/3.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMDAspects_testObject.h"
#import "NSObject+Aspects.h"

@interface TMDAspects : XCTestCase

@property (nonatomic, strong) TMDAspects_testObject *object;

@end

@implementation TMDAspects

- (void)setUp {
    self.object = [[TMDAspects_testObject alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAspects {
    [self.object methodForTesting];
    
    [self.object aspect_insertBeforeSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"1st insert before the method");
    }];
    [self.object aspect_insertBeforeSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"2nd insert before the method");
    }];
    [self.object aspect_insertBeforeSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"3rd insert before the method");
    }];
    
    [self.object aspect_insertAfterSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"1st insert after the method");
    }];
    
    [self.object aspect_insertAfterSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"2nd insert after the method");
    }];
    
    [self.object aspect_insertAfterSelector:@selector(methodForTesting) block:^(id<NSObjectAspectInfo> info) {
        NSLog(@"3rd insert after the method");
    }];
    
    [self.object methodForTesting];
}

@end
