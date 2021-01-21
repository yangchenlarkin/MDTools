//
//  UIView+MDUtils.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD/MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MDHudCustomViewProtocol <NSObject>

- (void)showLoading;
- (void)showSuccess;
- (void)showError;

@end

@interface UIView (MD_hud)

@property (nonatomic, readonly) MBProgressHUD *hud;

/*
 * + (void)setHudStyleWithBlock:设置全局样式
 * Block可以这么写：
 *  {
 *      if (!currentCustomView) {
 *          currentCustomView = [[CustomView alloc] init];
 *      }
 *      currentCustomView.xxx = xxx;
 *      hud.xxx = xxx;
 *      return currentCustomView;
 *  }
 */
+ (void)setHudStyleWithBlock:(UIView<MDHudCustomViewProtocol> * (^)(MBProgressHUD *hud, UIView<MDHudCustomViewProtocol> *currentCustomView))block;

#pragma mark - loading
/*
 * 将会增加引用计数
 */
+ (MBProgressHUD *)hudShowLoading;
+ (MBProgressHUD *)hudShowLoadingWithMessage:(NSString *)message;

#pragma mark - result
/*
 * if message is nil, hud will be hidden immediately
 * hud will hide after 2 seconds if success and 1 seconds if fail
 * 将会减少引用计数
 */
+ (MBProgressHUD *)hudError:(nullable NSError *)error;
+ (MBProgressHUD *)hudErrorWithMessage:(NSString *)message;
+ (MBProgressHUD *)hudSuccessWithMessage:(NSString *)message;
+ (MBProgressHUD *)hudResult:(BOOL)success message:(NSString *)message;

/*
 * if message is nil, hud will be hidden immediately
 * hud will hide after 2 seconds if success and 1 seconds if fail
 * 保持引用计数不变
 */
+ (MBProgressHUD *)hudShowError:(nullable NSError *)error;
+ (MBProgressHUD *)hudShowErrorWithMessage:(NSString *)message;
+ (MBProgressHUD *)hudShowSuccessWithMessage:(NSString *)message;
+ (MBProgressHUD *)hudShowResult:(BOOL)success message:(NSString *)message;

#pragma mark - hide
/*
 * 将会减少引用计数
 */
+ (MBProgressHUD *)hudHide;

@end


@interface UIView (MD_touch)

@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

@end

NS_ASSUME_NONNULL_END
