//
//  MDModuleManager.m
//  MDTools.h
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "MDModuleManager.h"
#import "MDProtocolImplementation.h"
#import <objc/runtime.h>
#import "UIViewController+ModuleManager.h"
#import <Aspects/Aspects.h>

typedef enum : NSUInteger {
    MDModuleManagerStateDisappear,
    MDModuleManagerStateAppearing,
    MDModuleManagerStateDisappearing,
    MDModuleManagerStateAppear,
} MDModuleManagerState;

@implementationProtocol(MDModuleManager)

#pragma mark - private method

- (void)setAppearState:(MDModuleManagerState)appearState {
    objc_setAssociatedObject(self, "__appearState", @(appearState), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (MDModuleManagerState)appearState {
    return [objc_getAssociatedObject(self, "__appearState") unsignedIntegerValue];
}

- (void)_viewWillAppearNotification:(NSNotification *)notification {
    UIViewController *vc = notification.userInfo[@"viewController"];
    BOOL animated = [notification.userInfo[@"animated"] boolValue];
    if (self.appearState == MDModuleManagerStateDisappear && vc.moduleManager == self) {
        NSUInteger count = [self _mutableViewControllers].count;
        if (count >= 2) {
            UIViewController *vc_1 = [[self _mutableViewControllers] pointerAtIndex:count - 1];
            UIViewController *vc_2 = [[self _mutableViewControllers] pointerAtIndex:count - 2];
            if ([vc_1 moduleManager] == [vc_2 moduleManager]) {
                return;
            }
        }
        self.appearState = MDModuleManagerStateAppearing;
        [self moduleWillAppear:animated];
    }
}

- (void)_viewDidAppearNotification:(NSNotification *)notification {
    UIViewController *vc = notification.userInfo[@"viewController"];
    BOOL animated = [notification.userInfo[@"animated"] boolValue];
    if (self.appearState == MDModuleManagerStateAppearing && vc.moduleManager == self) {
        NSUInteger count = [self _mutableViewControllers].count;
        if (count >= 2) {
            UIViewController *vc_1 = [[self _mutableViewControllers] pointerAtIndex:count - 1];
            UIViewController *vc_2 = [[self _mutableViewControllers] pointerAtIndex:count - 2];
            if ([vc_1 moduleManager] == [vc_2 moduleManager]) {
                return;
            }
        }
        self.appearState = MDModuleManagerStateAppear;
        [self moduleDidAppear:animated];
    }
}

- (void)_viewWillDisappearNotification:(NSNotification *)notification {
    UIViewController *vc = notification.userInfo[@"viewController"];
    BOOL animated = [notification.userInfo[@"animated"] boolValue];
    if (self.appearState == MDModuleManagerStateAppear && vc.moduleManager == self) {
        NSUInteger count = [self _mutableViewControllers].count;
        if (count >= 2) {
            UIViewController *vc_1 = [[self _mutableViewControllers] pointerAtIndex:count - 1];
            UIViewController *vc_2 = [[self _mutableViewControllers] pointerAtIndex:count - 2];
            if ([vc_1 moduleManager] == [vc_2 moduleManager]) {
                return;
            }
        }
        self.appearState = MDModuleManagerStateDisappearing;
        [self moduleWillDisappear:animated];
    }
}

- (void)_viewDidDisappearNotification:(NSNotification *)notification {
    UIViewController *vc = notification.userInfo[@"viewController"];
    BOOL animated = [notification.userInfo[@"animated"] boolValue];
    if (self.appearState != MDModuleManagerStateDisappear && vc.moduleManager == self) {
        NSUInteger count = [self _mutableViewControllers].count;
        if (count >= 2) {
            UIViewController *vc_1 = [[self _mutableViewControllers] pointerAtIndex:count - 1];
            UIViewController *vc_2 = [[self _mutableViewControllers] pointerAtIndex:count - 2];
            if ([vc_1 moduleManager] == [vc_2 moduleManager]) {
                return;
            }
        }
        self.appearState = MDModuleManagerStateDisappear;
        [self moduleDidDisappear:animated];
    }
}

- (NSPointerArray *)_mutableViewControllers {
    NSPointerArray *mutableViewControllerss = objc_getAssociatedObject(self, "__viewControllers");
    if (!mutableViewControllerss) {
        mutableViewControllerss = [NSPointerArray weakObjectsPointerArray];
        objc_setAssociatedObject(self, "__viewControllers", mutableViewControllerss, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [mutableViewControllerss addPointer:NULL];
    [mutableViewControllerss compact];
    return mutableViewControllerss;
}

- (void)_clearViewControllers {
    objc_setAssociatedObject(self, "__viewControllers", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_containViewController:(UIViewController *)viewController {
    if (!viewController) {
        return NO;
    }
    for (UIViewController *vc in self._mutableViewControllers) {
        if (vc == viewController) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)_isSuperModuleManagerOfViewController:(UIViewController *)viewController {
    id <MDModuleManager> mm = viewController.moduleManager;
    while (mm) {
        if (mm == self) {
            return YES;
        }
        mm = mm.superModuleManager;
    }
    return NO;
}

- (void)_removeViewControllers:(NSArray *)viewControllers {
    for (UIViewController *vc in viewControllers) {
        for (int i = 0; i < self._mutableViewControllers.count; i++) {
            if ([self._mutableViewControllers pointerAtIndex:i] == (__bridge void * _Nullable)(vc)) {
                [self._mutableViewControllers removePointerAtIndex:i];
                break;
            }
        }
    }
}

- (NSMutableArray *)_aspectTokens {
    NSMutableArray *_aspectTokens = objc_getAssociatedObject(self, "__aspectTokens");
    if (!_aspectTokens) {
        _aspectTokens = [NSMutableArray array];
        objc_setAssociatedObject(self, "__aspectTokens", _aspectTokens, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _aspectTokens;
}

- (id)_addAspectToObject:(id)object withSelector:(SEL)sel block:(void (^)(id<AspectInfo> info))block {
    NSError *error;
    id token = [object aspect_hookSelector:sel withOptions:AspectPositionBefore usingBlock:block error:&error];
    if (token) {
        [[self _aspectTokens] addObject:token];
    } else {
        NSLog(@"<Aspect: %@>", error);
    }
    return token;
}

- (void)_loadAspects {
    __weak typeof(self) weakSelf = self;

    [self _addAspectToObject:self.navigationController
     withSelector:@selector(popToViewController:animated:)
                       block:^(id<AspectInfo> info) {
                           typeof(weakSelf) self = weakSelf;
                           NSUInteger index = [self.navigationController.viewControllers indexOfObject:info.arguments[0]] + 1;
                           NSArray *res = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(index, self.navigationController.viewControllers.count - index)];
                           [res enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL * _Nonnull stop) {
                               if ([weakSelf _containViewController:viewController]) {
                                   viewController.moduleManager = nil;
                               }
                           }];
                           [self _removeViewControllers:res];
                       }];

    [self _addAspectToObject:self.navigationController
                withSelector:@selector(popToRootViewControllerAnimated:)
                       block:^(id<AspectInfo> info) {
                           typeof(weakSelf) self = weakSelf;
                           [self _clearViewControllers];
                           [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
                               if (idx) {
                                   [vc setModuleManager:nil];
                               } else {
                                   [self._mutableViewControllers addPointer:(__bridge void * _Nullable)vc];
                               }
                           }];
                           
                       }];

    [self _addAspectToObject:self.navigationController
                withSelector:@selector(setViewControllers:)
                           block:^(id<AspectInfo> info) {
                               typeof(weakSelf) self = weakSelf;
                               [self _clearViewControllers];
                               for (UIViewController *vc in [info arguments][0]) {
                                   if ([self _isSuperModuleManagerOfViewController:vc]) {
                                       [[self _mutableViewControllers] addPointer:(__bridge void * _Nullable)(vc)];
                                   }
                               }
                           }];

    [self _addAspectToObject:self.navigationController
                withSelector:@selector(setViewControllers:animated:)
                           block:^(id<AspectInfo> info) {
                               typeof(weakSelf) self = weakSelf;
                               [self _clearViewControllers];
                               for (UIViewController *vc in [info arguments][0]) {
                                   if ([self _isSuperModuleManagerOfViewController:vc]) {
                                       [[self _mutableViewControllers] addPointer:(__bridge void * _Nullable)(vc)];
                                   }
                               }
                           }];
}

- (void)_unloadAspects {
    for (id<AspectToken> token in self._aspectTokens) {
        [token remove];
    }
    [self._aspectTokens removeAllObjects];
}

- (void)dealloc {
    [self _unloadAspects];
}

#pragma mark - property

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController{
    if (self = [self init]) {
        self.navigationController = navigationController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewWillAppearNotification:) name:@"MDModuleManager_viewWillAppear:" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewDidAppearNotification:) name:@"MDModuleManager_viewDidAppear:" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewWillDisappearNotification:) name:@"MDModuleManager_viewWillDisappear:" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_viewDidDisappearNotification:) name:@"MDModuleManager_viewDidDisappear:" object:nil];
        
        __weak id __weak_self = self;
        [self aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^{
            [[NSNotificationCenter defaultCenter] removeObserver:__weak_self];
        } error:nil];
    }
    return self;
}

- (UIViewController *)rootViewController {
    if (self._mutableViewControllers.count == 0) {
        UIViewController *viewController = [self generateRootViewController];
        viewController.moduleManager = self;
        [self._mutableViewControllers insertPointer:(__bridge void * _Nullable)(viewController) atIndex:0];
        
        return viewController;
    }
    return [self._mutableViewControllers pointerAtIndex:0];
}

- (UIViewController *)tailViewController {
    if (self._mutableViewControllers.count == 0) {
        
        UIViewController *viewController = [self generateRootViewController];
        viewController.moduleManager = self;
        [self._mutableViewControllers insertPointer:(__bridge void * _Nullable)(viewController) atIndex:0];
        
        return viewController;
    }
    return [self._mutableViewControllers pointerAtIndex:self._mutableViewControllers.count - 1];
}

- (NSArray<UIViewController *> *)viewControllers {
    return [[self _mutableViewControllers] allObjects];
}

- (UINavigationController *)navigationController {
    id (^block)(void) = objc_getAssociatedObject(self, "__navigationController");
    UINavigationController *navigationController = block ? block() : nil;
    if (!navigationController) {
        navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
        [self _updateNavigationController:navigationController];
    }
    return navigationController;
}

- (void)setNavigationController:(UINavigationController *)navigationController {
    id (^block)(void) = objc_getAssociatedObject(self, "__navigationController");
    UINavigationController *_navigationController = block ? block() : nil;
    if (!_navigationController) {
        [self _updateNavigationController:navigationController];
    } else if (_navigationController != navigationController && navigationController) {
        NSCAssert(NO, @"navigationController can only be called once.");
    }
}

- (void)_updateNavigationController:(UINavigationController *)navigationController {
    [self _unloadAspects];
    __weak id weakObject = navigationController;
    id (^theBlock)(void) = ^{
        return weakObject;
    };
    objc_setAssociatedObject(self, "__navigationController", theBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (navigationController) {
        [self _loadAspects];
        if ([self respondsToSelector:@selector(didLoadNavigationController)]) {
            [self didLoadNavigationController];
        }
    }
}

#pragma mark - public method

- (UIViewController *)generateRootViewController {
    return [[UIViewController alloc] init];
}

- (void)moduleWillAppear:(BOOL)animated; {
    
}
- (void)moduleWillDisappear:(BOOL)animated; {
    
}
- (void)moduleDidAppear:(BOOL)animated; {
    
}
- (void)moduleDidDisappear:(BOOL)animated; {
    
}

- (NSArray<UIViewController *> *)popAllViewControllersAnimated:(BOOL)animated {
    if (!self.navigationController) {
        return nil;
    }
    if (self._mutableViewControllers.count >= self.navigationController.viewControllers.count) {
        return nil;
    }
    if (self.navigationController.viewControllers.lastObject != self.tailViewController) {
        return nil;
    }
    for (UIViewController *vc in self._mutableViewControllers) {
        [vc setModuleManager:nil];
    }
    [self moduleWillDisappear:animated];
    NSArray *res = self._mutableViewControllers.allObjects;
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self.rootViewController] - 1;
    UIViewController *toViewController = self.navigationController.viewControllers[index];
    if (self.superModuleManager) {
        return [self.superModuleManager popToViewController:toViewController animated:animated];
    }
    [self.navigationController popToViewController:toViewController animated:animated];
    
    return res;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    if (!self.navigationController) {
        return;
    }
    if (self._mutableViewControllers.count > self.navigationController.viewControllers.count) {
        return;
    }
    if (self.tailViewController != self.navigationController.viewControllers.lastObject) {
        return;
    }
    [self._mutableViewControllers insertPointer:(__bridge void * _Nullable)(viewController) atIndex:self._mutableViewControllers.count];
    if (self.superModuleManager) {
        [self.superModuleManager pushViewController:viewController animated:animated];
        viewController.moduleManager = self;
        return;
    }
    [self.navigationController pushViewController:viewController animated:animated];
    viewController.moduleManager = self;
}

- (void)popViewControllerAnimated:(BOOL)animated {
    if (!self.navigationController) {
        return;
    }
    if (self._mutableViewControllers.count > self.navigationController.viewControllers.count) {
        return;
    }
    if (self.tailViewController != self.navigationController.viewControllers.lastObject) {
        return;
    }
    if (self.rootViewController == self.tailViewController) {
        return;
    }
    if (self.superModuleManager) {
        [self.superModuleManager popViewControllerAnimated:animated];
        return;
    }
    [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.navigationController) {
        return nil;
    }
    if (![self _containViewController:viewController]) {
        return nil;
    }
    if (self._mutableViewControllers.count > self.navigationController.viewControllers.count) {
        return nil;
    }
    if (self.tailViewController != self.navigationController.viewControllers.lastObject) {
        return nil;
    }
    if (self.superModuleManager) {
        return [self.superModuleManager popToViewController:viewController animated:animated];
    }
    return [self.navigationController popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self popToViewController:self.rootViewController animated:animated];
}

- (void)preprocessWithFinish:(void (NS_NOESCAPE ^)(id error))finish {
    finish(nil);
}

- (BOOL)removeViewController:(UIViewController *)viewController {
    if (viewController.moduleManager != self) {
        return NO;
    }
    if (![self.navigationController.viewControllers containsObject:viewController]) {
        return YES;
    }
    for (int i = 0; i < [self _mutableViewControllers].count; i++) {
        UIViewController *vc = [[self _mutableViewControllers] pointerAtIndex:i];
        if (vc == viewController) {
            [[self _mutableViewControllers] removePointerAtIndex:i];
            NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
            [vcs removeObject:viewController];
            self.navigationController.viewControllers = vcs;
            return YES;
        }
    }
    return NO;
}

- (void)removeViewControllers:(NSArray<UIViewController *> *)viewControllers {
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    for (UIViewController *viewController in viewControllers) {
        if (viewController.moduleManager != self) {
            continue;
        }
        if (![self.navigationController.viewControllers containsObject:viewController]) {
            continue;
        }
        for (NSUInteger i = [self _mutableViewControllers].count - 1; i < [self _mutableViewControllers].count && i >= 0 ; i--) {
            UIViewController *vc = [[self _mutableViewControllers] pointerAtIndex:i];
            if (vc == viewController) {
                [vcs removeObject:viewController];
                [[self _mutableViewControllers] removePointerAtIndex:i];
            }
        }
    }
    self.navigationController.viewControllers = vcs;
}

#pragma mark - submodule

- (id<MDModuleManager>)superModuleManager {
    return objc_getAssociatedObject(self, "__superModuleManager");
}

- (void)setSuperModuleManager:(id<MDModuleManager>)superModuleManager {
    if (self.superModuleManager != superModuleManager) {
        objc_setAssociatedObject(self, "__superModuleManager", superModuleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)pushSubModuleManager:(id <MDModuleManager>)moduleManager animated:(BOOL)animated {
    moduleManager.superModuleManager = self;
    if (moduleManager.navigationController != self.navigationController)
        [moduleManager performSelector:@selector(_updateNavigationController:) withObject:self.navigationController];
    UIViewController *vc = moduleManager.rootViewController;
    [self pushViewController:vc animated:animated];
    vc.moduleManager = moduleManager;
}

@end
