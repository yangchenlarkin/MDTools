//
//  DemoViewController.m
//  test
//
//  Created by Larkin Yang on 2017/7/10.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoModuleManager.h"
#import "DemoView.h"

@interface DemoViewController ()

@property (nonatomic, strong) DemoView *view;

@end

@implementation DemoViewController
@dynamic view;

- (void)loadView {
    self.view = [[DemoView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //将控件（View层）的UI事件，与（ViewController层）的Method绑定
    [self.view.pushMM addTarget:self action:@selector(pushMM) forControlEvents:UIControlEventTouchUpInside];
    [self.view.popMM addTarget:self action:@selector(popMM) forControlEvents:UIControlEventTouchUpInside];
    [self.view.popViewController addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view.pushViewController addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view.pushViewControllerWithNavigation addTarget:self action:@selector(pushViewControllerWithNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.view.pop2root addTarget:self action:@selector(pop2root) forControlEvents:UIControlEventTouchUpInside];
    [self.view.pop2VC addTarget:self action:@selector(pop2VC) forControlEvents:UIControlEventTouchUpInside];
    [self.view.pushSubModuleManager addTarget:self action:@selector(pushSubModuleManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view.superModuleManagerPushVC addTarget:self action:@selector(superModuleManagerPushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view.popSuperModuleManager addTarget:self action:@selector(popSuperModuleManager) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.moduleManager) {
        self.title = [NSString stringWithFormat:@"%lu (MM: %lu)", (unsigned long)self.index, (unsigned long)[(DemoModuleManager *)self.moduleManager index]];
    } else {
        self.title = [NSString stringWithFormat:@"%lu", (unsigned long)self.index];
    }
}

- (void)dealloc {
    NSLog(@"<Dealloc DemoViewController>: %lu", (unsigned long)self.index);
}

//private method
- (int)_mmIndex {
    static int index = 0;
    index++;
    return index;
}

//给（ViewController层）提供方法，使其能够将（view层）产生的UI事件（例如button的tap事件）绑定到这些方法上。

- (void)popMM {
    [self.moduleManager popAllViewControllersAnimated:YES];
}

- (void)popViewController {
    [self.moduleManager popViewControllerAnimated:YES];
}

- (void)pushMM {
    DemoModuleManager *r = [[DemoModuleManager alloc] initWithNavigationController:self.navigationController];
    r.index = [self _mmIndex];
    [self.navigationController pushViewController:r.rootViewController animated:YES];
}

- (void)pushViewController {
    DemoViewController *viewController = [[DemoViewController alloc] init];
    viewController.index = self.index + 1;
    [self.moduleManager pushViewController:viewController animated:YES];
}

- (void)pushViewControllerWithNavigation {
    DemoViewController *viewController = [[DemoViewController alloc] init];
    viewController.index = self.index + 1;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pop2root {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pop2VC {
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}

- (void)pushSubModuleManager {
    DemoModuleManager *r = [[DemoModuleManager alloc] init];
    r.index = [self _mmIndex];
    [self.moduleManager pushSubModuleManager:r animated:YES];
}

- (void)superModuleManagerPushVC {
    DemoViewController *viewController = [[DemoViewController alloc] init];
    viewController.index = self.index + 1;
    [self.moduleManager.superModuleManager pushViewController:viewController animated:YES];
}

- (void)popSuperModuleManager {
    [self.moduleManager.superModuleManager popAllViewControllersAnimated:YES];
}

@end
