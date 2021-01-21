//
//  UIControl+MDUtils.m
//  RideSharing
//
//  Created by 杨晨 on 2019/5/16.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "UIControl+MDUtils.h"
#import <objc/runtime.h>
#import "MDListener.h"
#import "MDCommonDefines.h"
#import "Aspects.h"

@implementation UIControl (utils)

- (NSMutableSet *)aspectTokens {
    NSMutableSet *set = objc_getAssociatedObject(self, "aspectTokens");
    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, "aspectTokens", set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
}

- (MDListener <id <UIControlStateDidChange>> *)listener {
    MDListener <id <UIControlStateDidChange>> *l = objc_getAssociatedObject(self, "listener");
    if (!l) {
        l = [[MDListener <id <UIControlStateDidChange>> alloc] init];
        objc_setAssociatedObject(self, "listener", l, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return l;
}

- (void)addControlStateListener:(id<UIControlStateDidChange>)listener {
    if ([self aspectTokens].count == 0) {
        id token = nil;
        NSError *error = nil;
        MDWeakify(self);
        
        token = [self aspect_hookSelector:@selector(setHighlighted:) withOptions:AspectPositionAfter usingBlock:^{
            MDStrongify(self);
            [self didChange];
        } error:&error];
        if (token) {
            [[self aspectTokens] addObject:token];
        }
        
        token = [self aspect_hookSelector:@selector(setEnabled:) withOptions:AspectPositionAfter usingBlock:^{
            MDStrongify(self);
            [self didChange];
        } error:&error];
        if (token) {
            [[self aspectTokens] addObject:token];
        }
        
        token = [self aspect_hookSelector:@selector(setSelected:) withOptions:AspectPositionAfter usingBlock:^{
            MDStrongify(self);
            [self didChange];
        } error:&error];
        if (token) {
            [[self aspectTokens] addObject:token];
        }
    }
    
    [[self listener] addListener:listener];
}

- (void)didChange {
    UIControlState lastState = [objc_getAssociatedObject(self, "state") unsignedIntegerValue];
    if (self.state != lastState) {
        [[self listener] performAction:^(id<UIControlStateDidChange>  _Nonnull listener) {
            if ([listener respondsToSelector:@selector(controlStateDidChange:)]) {
                [listener controlStateDidChange:self];
            }
        }];
    }
    objc_setAssociatedObject(self, "state", @(self.state), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
