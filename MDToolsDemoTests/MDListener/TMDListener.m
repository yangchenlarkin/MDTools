//
//  TMDListener.m
//  LToolsDemoTests
//
//  Created by Larkin Yang on 2017/10/9.
//  Copyright © 2017年 Larkin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDListener.h"


//listener protocol
@protocol TMDListenerProtocol <NSObject>

- (void)didGetNotification;

@end


//listener
@interface TListenerObject : NSObject <TMDListenerProtocol>

@property (nonatomic, copy) NSString *desc;

@end

@implementation TListenerObject

- (instancetype)initWithDesc:(NSString *)desc {
    if (self = [super init]) {
        self.desc = desc;
    }
    return self;
}

- (void)didGetNotification {
    NSLog(@"%@", self.desc);
}

@end




@interface TMDListener : XCTestCase

@property (nonatomic, strong) TListenerObject *listenerObject1;
@property (nonatomic, strong) TListenerObject *listenerObject2;
@property (nonatomic, strong) TListenerObject *listenerObject3;

@property (nonatomic, strong) MDListener<id <TMDListenerProtocol>> *listeners;

@end

@implementation TMDListener

- (void)setUp {
    self.listenerObject1 = [[TListenerObject alloc] initWithDesc:@"object1"];
    self.listenerObject2 = [[TListenerObject alloc] initWithDesc:@"object2"];
    self.listenerObject3 = [[TListenerObject alloc] initWithDesc:@"object3"];
    
    self.listeners = [[MDListener<id <TMDListenerProtocol>> alloc] init];
    
    [self.listeners addListener:self.listenerObject1];
    [self.listeners addListener:self.listenerObject2];
    [self.listeners addListener:self.listenerObject3];
    
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testListener {
    [self.listeners performAction:^(id<TMDListenerProtocol>  _Nonnull listener) {
        [listener didGetNotification];
    }];
}

@end
