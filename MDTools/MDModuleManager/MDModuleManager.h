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
#pragma mark - 子类重写
- (UIViewController *)generateRootViewController;
- (void)didLoadNavigationController;

//当前ViewController被当前Module管理，且没有被当前Module的任何子孙Module管理，则当前module状态为appear
- (void)moduleWillAppear:(BOOL)animated;
- (void)moduleWillDisappear:(BOOL)animated;
- (void)moduleDidAppear:(BOOL)animated;
- (void)moduleDidDisappear:(BOOL)animated;

#pragma mark - public method
@property (nonatomic, readonly) UINavigationController *navigationController;

/*
 * navigationController如果传空，则会以self.rootViewController为navigationController的rootViewController生成一个navigationController
 */
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
