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

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(_viewDidAppear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    static dispatch_once_t onceToken3;
    dispatch_once(&onceToken3, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(viewWillDisappear:);
        SEL swizzledSelector = @selector(_viewWillDisappear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    static dispatch_once_t onceToken4;
    dispatch_once(&onceToken4, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(viewDidDisappear:);
        SEL swizzledSelector = @selector(_viewDidDisappear:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (id<MDModuleManager>)moduleManager {
    return objc_getAssociatedObject(self, "__moduleManager");
}

- (void)setModuleManager:(id<MDModuleManager>)moduleManager {
    objc_setAssociatedObject(self, "__moduleManager", moduleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_viewWillAppear:(BOOL)animated {
    [self _viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MDModuleManager_viewWillAppear:" object:self userInfo:@{
                                                                                                                         @"viewController": self,
                                                                                                                        @"animated": @(animated)
                                                                                                                        }];
}

- (void)_viewDidAppear:(BOOL)animated {
    [self _viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MDModuleManager_viewDidAppear:" object:self userInfo:@{
                                                                                                                        @"viewController": self,
                                                                                                                        @"animated": @(animated)
                                                                                                                        }];
}

- (void)_viewWillDisappear:(BOOL)animated {
    [self _viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MDModuleManager_viewWillDisappear:" object:self userInfo:@{
                                                                                                                            @"viewController": self,
                                                                                                                            @"animated": @(animated)
                                                                                                                            }];
}

- (void)_viewDidDisappear:(BOOL)animated {
    [self _viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MDModuleManager_viewDidDisappear:" object:self userInfo:@{
                                                                                                                           @"viewController": self,
                                                                                                                           @"animated": @(animated)
                                                                                                                           }];
}

@end
