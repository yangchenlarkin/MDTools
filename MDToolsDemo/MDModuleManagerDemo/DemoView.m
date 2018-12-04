//
//  DemoView.m
//  Mobi
//
//  Created by Larkin Yang on 2017/7/14.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "DemoView.h"

@interface DemoView ()

@property (nonatomic, strong) UIButton *popMM;
@property (nonatomic, strong) UIButton *pushMM;
@property (nonatomic, strong) UIButton *popViewController;
@property (nonatomic, strong) UIButton *pushViewController;
@property (nonatomic, strong) UIButton *pushViewControllerWithNavigation;
@property (nonatomic, strong) UIButton *pop2root;
@property (nonatomic, strong) UIButton *pop2VC;

@property (nonatomic, strong) UIButton *pushSubModuleManager;
@property (nonatomic, strong) UIButton *superModuleManagerPushVC;
@property (nonatomic, strong) UIButton *popSuperModuleManager;

@end


@implementation DemoView

//初始化控件
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.popMM = [[UIButton alloc] init];
        [self.popMM setTitle:@"pop MM" forState:UIControlStateNormal];
        self.popMM.backgroundColor = [UIColor grayColor];
        [self addSubview:self.popMM];
        
        self.pushMM = [[UIButton alloc] init];
        [self.pushMM setTitle:@"push MM" forState:UIControlStateNormal];
        self.pushMM.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pushMM];
        
        self.popViewController = [[UIButton alloc] init];
        [self.popViewController setTitle:@"pop VC" forState:UIControlStateNormal];
        self.popViewController.backgroundColor = [UIColor grayColor];
        [self addSubview:self.popViewController];
        
        self.pushViewController = [[UIButton alloc] init];
        [self.pushViewController setTitle:@"push VC" forState:UIControlStateNormal];
        self.pushViewController.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pushViewController];
        
        self.pushViewControllerWithNavigation = [[UIButton alloc] init];
        [self.pushViewControllerWithNavigation setTitle:@"push VC-nav" forState:UIControlStateNormal];
        self.pushViewControllerWithNavigation.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pushViewControllerWithNavigation];
        
        self.pop2root = [[UIButton alloc] init];
        [self.pop2root setTitle:@"pop to root-nav" forState:UIControlStateNormal];
        self.pop2root.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pop2root];
        
        self.pop2VC = [[UIButton alloc] init];
        [self.pop2VC setTitle:@"pop to vc-nav" forState:UIControlStateNormal];
        self.pop2VC.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pop2VC];
        
        self.pushSubModuleManager = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pushSubModuleManager setTitle:@"push subMM" forState:UIControlStateNormal];
        self.pushViewControllerWithNavigation.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pushSubModuleManager];
        
        self.superModuleManagerPushVC = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.superModuleManagerPushVC setTitle:@"superMM pushVC" forState:UIControlStateNormal];
        self.pushViewControllerWithNavigation.backgroundColor = [UIColor grayColor];
        [self addSubview:self.superModuleManagerPushVC];
        
        self.popSuperModuleManager = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.popSuperModuleManager setTitle:@"pop supMM" forState:UIControlStateNormal];
        self.popSuperModuleManager.backgroundColor = [UIColor grayColor];
        [self addSubview:self.popSuperModuleManager];
    }
    return self;
}

//刷新控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.popMM.frame = CGRectMake(0, 101, self.frame.size.width / 2 - 1, 100);
    self.pushMM.frame = CGRectMake(self.frame.size.width / 2, 101, self.frame.size.width / 2, 100);
    self.popViewController.frame = CGRectMake(0, 202, self.frame.size.width / 2 - 1, 100);
    self.pushViewController.frame = CGRectMake(self.frame.size.width / 2, 202, self.frame.size.width / 2, 100);
    self.pushViewControllerWithNavigation.frame = CGRectMake(self.frame.size.width / 2.f, 303, self.frame.size.width / 2.f, 100);
    self.pop2root.frame = CGRectMake(0, 303, self.frame.size.width / 2.f, 100);
    self.pop2VC.frame = CGRectMake(0, 403, self.frame.size.width / 2.f, 100);
    
    self.pushSubModuleManager.frame = CGRectMake(0, 505, self.frame.size.width / 2.f, 100);
    self.superModuleManagerPushVC.frame = CGRectMake(self.frame.size.width / 2.f, 505, self.frame.size.width / 2.f, 100);
    self.popSuperModuleManager.frame = CGRectMake(0, 606, self.frame.size.width, 50);
}

@end
