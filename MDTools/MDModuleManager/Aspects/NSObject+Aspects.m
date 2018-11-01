//
//  NSObject+Aspects.m
//  Mobi
//
//  Created by Larkin Yang on 2017/8/12.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSObject+Aspects.h"
#import "Aspects.h"
#import <objc/runtime.h>

@interface AspectProxy : NSObject

@property (nonatomic, weak) __kindof NSObject *object;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary<NSString *, id> *> *before;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableDictionary<NSString *, id> *> *after;

- (NSString *)aspect_insertBeforeSelector:(SEL)sel block:(void (^)(id<AspectInfo> info))block;
- (NSString *)aspect_insertAfterSelector:(SEL)sel block:(void (^)(id<AspectInfo> info))block;
- (void)aspect_removeBlock:(NSString *)blockId;

@end

@implementation AspectProxy

+ (id)proxyForObject:(id)obj {
    AspectProxy *instance = [[AspectProxy alloc] init];
    instance.object = obj;
    return instance;
}

- (NSString *)genIdentify:(SEL)sel after:(BOOL)after {
    NSString *res = nil;
    NSDictionary *dic = after ? self.after : self.before;
    while (!res) {
        NSString *tmp =
        after ? [NSString stringWithFormat:@"%@_after_%lu-%u", NSStringFromSelector(sel), self.after[NSStringFromSelector(sel)].count, arc4random()] :
        [NSString stringWithFormat:@"%@_before_%lu-%u", NSStringFromSelector(sel), self.before[NSStringFromSelector(sel)].count, arc4random()];
        if (![[dic[NSStringFromSelector(sel)] allKeys] containsObject:tmp]) {
            res = tmp;
        }
    }
    return res;
}

- (NSString *)aspect_insertBeforeSelector:(SEL)sel block:(void (^)(id<AspectInfo> info))block {
    if (!self.before[NSStringFromSelector(sel)]) {
        self.before[NSStringFromSelector(sel)] = [NSMutableDictionary dictionary];
        __weak AspectProxy *__weak_self = self;
        [self.object aspect_hookSelector:sel withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
            AspectProxy *self = __weak_self;
            NSDictionary *copyBlocks = self.before[NSStringFromSelector(sel)].copy;
            for (id key in copyBlocks) {
                void (^block)(id<AspectInfo> info) = copyBlocks[key];
                block(info);
            }
        } error:nil];
    }
    NSString *identify = [self genIdentify:sel after:NO];
    self.before[NSStringFromSelector(sel)][identify] = block;
    return identify;
}

- (NSString *)aspect_insertAfterSelector:(SEL)sel block:(void (^)(id<AspectInfo> info))block {
    if (!self.after[NSStringFromSelector(sel)]) {
        self.after[NSStringFromSelector(sel)] = [NSMutableDictionary dictionary];
        __weak AspectProxy *__weak_self = self;
        [self.object aspect_hookSelector:sel withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
            AspectProxy *self = __weak_self;
            for (id key in self.after[NSStringFromSelector(sel)]) {
                void (^block)(id<AspectInfo> info) = self.after[NSStringFromSelector(sel)][key];
                block(info);
            }
        } error:nil];
    }
    NSString *identify = [self genIdentify:sel after:YES];
    self.after[NSStringFromSelector(sel)][identify] = block;
    return identify;
}

- (void)aspect_removeBlock:(NSString *)blockId {
    NSArray *keys = [blockId componentsSeparatedByString:@"_"];
    if ([keys[1] isEqualToString:@"before"]) {
        [self.before[keys[0]] removeObjectForKey:blockId];
    } else {
        [self.after[keys[0]] removeObjectForKey:blockId];
    }
}

- (NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,id> *> *)before {
    if (!_before) {
        _before = [NSMutableDictionary dictionary];
    }
    return _before;
}

- (NSMutableDictionary<NSString *,NSMutableDictionary<NSString *,id> *> *)after {
    if (!_after) {
        _after = [NSMutableDictionary dictionary];
    }
    return _after;
}

@end

@implementation NSObject (MAspect)

- (AspectProxy *)_Aspect_proxy {
    AspectProxy *p = objc_getAssociatedObject(self, "_Aspect_proxy");
    if (!p) {
        p = [AspectProxy proxyForObject:self];
        objc_setAssociatedObject(self, "_Aspect_proxy", p, OBJC_ASSOCIATION_RETAIN);
    }
    return p;
}


- (NSString *)aspect_insertBeforeSelector:(SEL)sel block:(void (^)(id<NSObjectAspectInfo> info))block {
    return [self._Aspect_proxy aspect_insertBeforeSelector:sel block:(void (^)(id<AspectInfo> info))block];
}
- (NSString *)aspect_insertAfterSelector:(SEL)sel block:(void (^)(id<NSObjectAspectInfo> info))block {
    return [self._Aspect_proxy aspect_insertAfterSelector:sel block:(void (^)(id<AspectInfo> info))block];
}
- (void)aspect_removeBlock:(NSString *)blockId {
    return [self._Aspect_proxy aspect_removeBlock:blockId];
}
@end
