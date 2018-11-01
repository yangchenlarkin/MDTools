//
//  UIViewController+ModuleManager.h
//  MVVMsDemo
//
//  Created by Larkin Yang on 2017/7/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ModuleManager;

@interface UIViewController (ModuleManager)

@property (nonatomic, strong) id<ModuleManager> moduleManager;

@end


