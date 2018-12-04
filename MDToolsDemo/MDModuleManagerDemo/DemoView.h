//
//  DemoView.h
//  Mobi
//
//  Created by Larkin Yang on 2017/7/14.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DemoView : UIView
//将必要控件暴露出去，供（ViewModel层）添加UI事件绑定和控制控件属性
@property (nonatomic, readonly) UIButton *popMM;
@property (nonatomic, readonly) UIButton *pushMM;
@property (nonatomic, readonly) UIButton *popViewController;
@property (nonatomic, readonly) UIButton *pushViewController;
@property (nonatomic, readonly) UIButton *pushViewControllerWithNavigation;
@property (nonatomic, readonly) UIButton *pop2root;
@property (nonatomic, readonly) UIButton *pop2VC;

@property (nonatomic, readonly) UIButton *pushSubModuleManager;
@property (nonatomic, readonly) UIButton *superModuleManagerPushVC;
@property (nonatomic, readonly) UIButton *popSuperModuleManager;

@end
