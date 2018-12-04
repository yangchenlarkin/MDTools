//
//  MDModuleManager.h
//  MDTools.h
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+ModuleManager.h"
#import "MDProtocolImplementation.h"

@protocol MDModuleManager <NSObject>
@optional
- (UIViewController *)generateRootViewController;


@property (nonatomic, strong) UINavigationController *navigationController;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;


@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *tailViewController;
@property (nonatomic, strong, readonly) NSArray <UIViewController *> *viewControllers;


- (NSArray<UIViewController *> *)popAllViewControllersAnimated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated;

- (void)preprocessWithFinish:(void (NS_NOESCAPE ^)(id error))finish;

- (BOOL)removeViewController:(UIViewController *)viewController;
- (void)removeViewControllers:(NSArray <UIViewController *> *)viewControllers;

#pragma mark - submodule

@property (nonatomic, strong) id <MDModuleManager> superModuleManager;
- (void)pushSubModuleManager:(id <MDModuleManager>)moduleManager animated:(BOOL)animated;

@end
