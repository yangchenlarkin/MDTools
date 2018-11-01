//
//  UIViewController+ModuleManager.m
//  MVVMsDemo
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "UIViewController+ModuleManager.h"
#import <objc/runtime.h>

@implementation UIViewController (ModuleManager)

- (id<ModuleManager>)moduleManager {
    return objc_getAssociatedObject(self, "__moduleManager");
}

- (void)setModuleManager:(id<ModuleManager>)moduleManager {
    objc_setAssociatedObject(self, "__moduleManager", moduleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
