//
//  MDKeyValueGetter.m
//  MDTools
//
//  Created by 杨晨 on 2021/8/12.
//

#import "MDKeyValueGetter.h"
#import "MDARC.h"

@interface MDKeyValueGetter ()

@property (nonatomic, strong) MDKeyValueMemoryCache *memoryCache;
@property (nonatomic, strong) MDKeyValueDiskCache *diskCache;
@property (nonatomic, copy) MDKeyValueGetterBlock getter;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet <MDKeyValueGetterResult> *> *callbacks;

@end

@implementation MDKeyValueGetter

+ (MDKeyValueGetter *)getterWithCacheRootPath:(NSString *)rootPath getterBlock:(MDKeyValueGetterBlock)getter; {
    MDKeyValueGetter *res = [[MDKeyValueGetter alloc] init];
    res.memoryCache = [[MDKeyValueMemoryCache alloc] init];
    res.diskCache = [MDKeyValueDiskCache cacheWithRootPath:rootPath];
    res.getter = getter;
    res.callbacks = [NSMutableDictionary dictionary];
    return res;
}

- (void)getObjectForKey:(NSString *)key callback:(MDKeyValueGetterResult)callback; {
    if (!callback) {
        return;
    }
    if (!key) {
        callback(key, nil, [NSError errorWithDomain:@"MDKeyValueGetter.getObjectForKey" code:-1 userInfo:@{
            NSLocalizedDescriptionKey: @"需要传入key",
        }]);
        return;
    }
    id res = nil;
    res = [self.memoryCache getObjectForKey:key];
    if (res) {
        callback(key, res, nil);
        return;
    }
    res = [self.diskCache objectForKey:key];
    if (res) {
        [self.memoryCache cacheObject:res forKey:key];
        callback(key, res, nil);
        return;
    }
    @synchronized (self.callbacks) {
        if (!self.callbacks[key]) {
            self.callbacks[key] = [NSMutableSet set];
        }
    }
    @synchronized (self.callbacks[key]) {
        [self.callbacks[key] addObject:callback];
        if (self.callbacks[key].count > 1) {
            return;
        }
    }
    MDWeakify(self);
    self.getter(key, ^(NSString * _Nullable key, id  _Nullable object, NSError * _Nullable error) {
        MDStrongify(self);
        @synchronized (self.callbacks[key]) {
            for (MDKeyValueGetterResult _callback in self.callbacks[key]) {
                _callback(key, object, error);
            }
            [self.callbacks[key] removeAllObjects];
        }
        [self.memoryCache cacheObject:object forKey:key];
        [self.diskCache cacheObject:object forKey:key];
    });
}

- (void)clear; {
    [self.memoryCache releaseWithPercent:1];
    [self.diskCache clear];
}

- (void)setD2o:(MDKeyValueDiskCache_d2o)d2o {
    self.diskCache.d2o = d2o;
}

- (MDKeyValueDiskCache_d2o)d2o {
    return self.diskCache.d2o;
}

- (void)setO2d:(MDKeyValueDiskCache_o2d)o2d {
    self.diskCache.o2d = o2d;
}

- (MDKeyValueDiskCache_o2d)o2d {
    return self.diskCache.o2d;
}

@end
