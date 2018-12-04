//
//  MDMMImageModuleManager.m
//  MDToolsDemo
//
//  Created by Larkin Yang on 2018/12/4.
//  Copyright © 2018 Larkin. All rights reserved.
//

#import "MDMMImageModuleManager.h"
#import "MDMMImageHomeViewController.h"

@implementation MDMMImageModuleManager
__ImplementationProtocol__

- (UIViewController *)generateRootViewController {
    return [[MDMMImageHomeViewController alloc] init];
}


@end
