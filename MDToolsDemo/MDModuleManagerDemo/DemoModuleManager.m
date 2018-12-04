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

- (void)dealloc {
    NSLog(@"<Dealloc DemoModuleManager>: %lu", (unsigned long)self.index);
}

@end
