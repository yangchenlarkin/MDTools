//
//  DemoModuleManager.m
//  MVVMsDemo
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "DemoModuleManager.h"
#import "DemoViewController.h"
#import "MDProtocolImplementation.h"

@implementation DemoModuleManager
__ImplementationProtocol__
- (UIViewController *)generateRootViewController {
    return [[DemoViewController alloc] init];
}

- (void)moduleWillAppear:(BOOL)animated {
    NSLog(@"<wil app DemoModuleManager>: %lu", (unsigned long)self.index);
}

- (void)moduleDidAppear:(BOOL)animated {
    NSLog(@"<did app DemoModuleManager>: %lu", (unsigned long)self.index);
}

- (void)moduleWillDisappear:(BOOL)animated {
    NSLog(@"<wil dis DemoModuleManager>: %lu", (unsigned long)self.index);
}

- (void)moduleDidDisappear:(BOOL)animated {
    NSLog(@"<did dis DemoModuleManager>: %lu", (unsigned long)self.index);
}

- (void)dealloc {
    NSLog(@"<Dealloc DemoModuleManager>: %lu", (unsigned long)self.index);
}

@end
