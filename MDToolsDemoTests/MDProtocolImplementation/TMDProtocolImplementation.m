//
//  TMDProtocolImplementation.m
//  MDToolsDemoTests
//
//  Created by Larkin Yang on 2018/12/3.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TMDProtocolImplementation_protocol.h"

@interface TMDProtocolImplementation : XCTestCase <TMDProtocolImplementation_protocol>

@end

@implementation TMDProtocolImplementation

__ImplementationProtocol__

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testProtocolImplementation {
    NSLog(@"%@", [self testMethod]);
}

@end
