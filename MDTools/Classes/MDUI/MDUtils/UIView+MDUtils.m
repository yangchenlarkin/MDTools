//
//  UIView+MDUtils.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/10.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "UIView+MDUtils.h"
#import <objc/runtime.h>

NSString *const kUIViewController_utils_hud = @"kUIViewController_utils_hud";

@implementation UIView (MD_hud)

+ (UIView<MDHudCustomViewProtocol> * (^)(MBProgressHUD *hud, UIView<MDHudCustomViewProtocol> *currentCustomView))styleBlock {
    return objc_getAssociatedObject([UIView class], "styleBlock");
}

+ (void)setStyleBlock:(UIView<MDHudCustomViewProtocol> * (^)(MBProgressHUD *hud, UIView<MDHudCustomViewProtocol> *currentCustomView))styleBlock {
    objc_setAssociatedObject([UIView class], "styleBlock", styleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)setHudStyleWithBlock:(UIView<MDHudCustomViewProtocol> * (^)(MBProgressHUD *hud, UIView<MDHudCustomViewProtocol> *currentCustomView))block {
    [self setStyleBlock:block];
}

- (MBProgressHUD *)hud {
    @synchronized (self) {
        MBProgressHUD *hud = objc_getAssociatedObject(self, CFBridgingRetain(kUIViewController_utils_hud));
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self];
            
            hud.mode = MBProgressHUDModeCustomView;
            hud.offset = CGPointMake(0, -30);
            
            hud.label.text = @" ";
            
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.backgroundColor = [UIColor clearColor];
            
            hud.removeFromSuperViewOnHide = YES;
            
            objc_setAssociatedObject(self, CFBridgingRetain(kUIViewController_utils_hud), hud, OBJC_ASSOCIATION_RETAIN);
            
            [self addSubview:hud];
        }
        
        UIView<MDHudCustomViewProtocol> * (^block)(MBProgressHUD *hud, UIView<MDHudCustomViewProtocol> *currentCustomView) = [[self class] styleBlock];
        if (block) {
            hud.customView = block(hud, [hud.customView conformsToProtocol:@protocol(MDHudCustomViewProtocol)] ? (UIView <MDHudCustomViewProtocol> *)hud.customView : nil);
        }
        
        return hud;
    }
}

- (UIView<MDHudCustomViewProtocol> *)hudLoadingView {
    return (UIView<MDHudCustomViewProtocol> *)self.hud.customView;
}

#pragma mark - loading

- (MBProgressHUD *)hudShowLoading {
    return [self hudShowLoadingWithMessage:@""];
}

- (MBProgressHUD *)hudShowLoadingWithMessage:(NSString *)message {
    [[self hudLoadingView] showLoading];
    self.hud.detailsLabel.text = message;
    [self _hudShow];
    return self.hud;
}

#pragma mark - result

- (MBProgressHUD *)hudError:(NSError *)error {
    return [self hudErrorWithMessage:error.localizedDescription];
}

- (MBProgressHUD *)hudErrorWithMessage:(NSString *)message {
    if (message.length) {
        [[self hudLoadingView] showError];
        self.hud.detailsLabel.text = message;
        [self _hudHideWithDelay:2];
    } else {
        [self _hudHideWithDelay:0];
    }
    return self.hud;
}

- (MBProgressHUD *)hudSuccessWithMessage:(NSString *)message {
    if (message.length) {
        [[self hudLoadingView] showSuccess];
        self.hud.detailsLabel.text = message;
        [self _hudHideWithDelay:1];
    } else {
        [self _hudHideWithDelay:0];
    }
    return self.hud;
}

- (MBProgressHUD *)hudResult:(BOOL)success message:(NSString *)message {
    if (success) {
        return [self hudSuccessWithMessage:message];
    } else {
        return [self hudErrorWithMessage:message];
    }
}

#pragma mark - hide

- (MBProgressHUD *)hudHide {
    [self _hudHideWithDelay:0];
    return self.hud;
}

#pragma mark - private method

- (void)_hudHideWithDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self _decreaseHudCount] == 0) {
            [self.hud hideAnimated:YES];
        }
    });
}

- (void)_hudShow {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self _increaseHudCount] == 1) {
            [self.hud showAnimated:YES];
            [self addSubview:self.hud];
        }
    });
}

- (NSInteger)_increaseHudCount {
    NSInteger count = [objc_getAssociatedObject(self, "_hud_count") integerValue];
    count++;
    objc_setAssociatedObject(self, "_hud_count", @(count), OBJC_ASSOCIATION_COPY_NONATOMIC);
    return count;
}

- (NSInteger)_decreaseHudCount {
    NSInteger count = [objc_getAssociatedObject(self, "_hud_count") integerValue];
    count--;
    objc_setAssociatedObject(self, "_hud_count", @(count), OBJC_ASSOCIATION_COPY_NONATOMIC);
    return count;
}


#pragma mark - api
#pragma mark -

+ (MBProgressHUD *)hudShowLoading; {
    return [[UIApplication sharedApplication].delegate.window hudShowLoading];
}
+ (MBProgressHUD *)hudShowLoadingWithMessage:(NSString *)message; {
    return [[UIApplication sharedApplication].delegate.window hudShowLoadingWithMessage:message];
}
+ (MBProgressHUD *)hudError:(nullable NSError *)error; {
    return [[UIApplication sharedApplication].delegate.window hudError:error];
}
+ (MBProgressHUD *)hudErrorWithMessage:(NSString *)message; {
    return [[UIApplication sharedApplication].delegate.window hudErrorWithMessage:message];
}
+ (MBProgressHUD *)hudSuccessWithMessage:(NSString *)message; {
    return [[UIApplication sharedApplication].delegate.window hudSuccessWithMessage:message];
}
+ (MBProgressHUD *)hudResult:(BOOL)success message:(NSString *)message; {
    return [[UIApplication sharedApplication].delegate.window hudResult:success message:message];
}
+ (MBProgressHUD *)hudShowError:(nullable NSError *)error; {
    [[[UIApplication sharedApplication].delegate window] _hudShow];
    return [[UIApplication sharedApplication].delegate.window hudError:error];
}
+ (MBProgressHUD *)hudShowErrorWithMessage:(NSString *)message; {
    [[[UIApplication sharedApplication].delegate window] _hudShow];
    return [[UIApplication sharedApplication].delegate.window hudErrorWithMessage:message];
}
+ (MBProgressHUD *)hudShowSuccessWithMessage:(NSString *)message; {
    [[[UIApplication sharedApplication].delegate window] _hudShow];
    return [[UIApplication sharedApplication].delegate.window hudSuccessWithMessage:message];
}
+ (MBProgressHUD *)hudShowResult:(BOOL)success message:(NSString *)message; {
    [[[UIApplication sharedApplication].delegate window] _hudShow];
    return [[UIApplication sharedApplication].delegate.window hudResult:success message:message];
}
+ (MBProgressHUD *)hudHide; {
    return [[UIApplication sharedApplication].delegate.window hudHide];
}

@end

@implementation UIView (touch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(pointInside:withEvent:);
        SEL swizzledSelector = @selector(_pointInside:withEvent:);
        
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

- (BOOL)_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self _pointInside:point withEvent:event]) {
        return YES;
    }
    return CGRectContainsPoint(CGRectMake(-self.touchAreaInsets.left,
                                          -self.touchAreaInsets.top,
                                          self.bounds.size.width + self.touchAreaInsets.left + self.touchAreaInsets.right,
                                          self.bounds.size.height + self.touchAreaInsets.top + self.touchAreaInsets.bottom), point);
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *v = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, "touchAreaInsets", v, OBJC_ASSOCIATION_COPY);
}

- (UIEdgeInsets)touchAreaInsets {
    NSValue *v = objc_getAssociatedObject(self, "touchAreaInsets");
    return [v UIEdgeInsetsValue];
}

@end
