//
//  MDObjectCacher.m
//  HMI
//
//  Created by 杨晨 on 2019/7/12.
//  Copyright © 2019 杨晨. All rights reserved.
//

#import "MDObjectCacher.h"
#import "MDCommonDefines.h"

@interface MDObjectCacher()

@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> *cachedObjectSetsLow;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> *cachedObjectSetsDefault;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> *cachedObjectSetsHigh;

@end

@implementation MDObjectCacher

__SHARED_INSTANCE__(MDObjectCacher)

LAZY_LOAD(NSMutableDictionary, cachedObjectSetsLow)
LAZY_LOAD(NSMutableDictionary, cachedObjectSetsDefault)
LAZY_LOAD(NSMutableDictionary, cachedObjectSetsHigh)

- (instancetype)init {
    if (self = [super init]) {
        _capacity = 1024;
    }
    return self;
}

+ (void)clearWithLevel:(MDObjectCacherLevel)level {
    switch (level) {
        case MDObjectCacherLevelHigh:
            [self sharedInstance].cachedObjectSetsHigh = nil;
            
        case MDObjectCacherLevelDefault:
            [self sharedInstance].cachedObjectSetsDefault = nil;
            
        case MDObjectCacherLevelLow:
            [self sharedInstance].cachedObjectSetsLow = nil;
    }
}

+ (NSMutableSet *)cachedObjectSetForKey:(NSString *)key level:(MDObjectCacherLevel)level {
    NSMutableDictionary *dictionary = nil;
    switch (level) {
        case MDObjectCacherLevelLow:
            dictionary = [self sharedInstance].cachedObjectSetsLow;
            break;
        case MDObjectCacherLevelDefault:
            dictionary = [self sharedInstance].cachedObjectSetsDefault;
            break;
        case MDObjectCacherLevelHigh:
            dictionary = [self sharedInstance].cachedObjectSetsHigh;
            break;
    }
    if (!dictionary[key]) {
        dictionary[key] = [NSMutableSet setWithCapacity:[self sharedInstance].capacity];
    }
    return dictionary[key];
}

+ (void)setCapacity:(NSUInteger)capacity {
    [self sharedInstance].capacity = capacity;
}

+ (id)dequeueObjectForKey:(NSString *)key {
    @synchronized (self) {
        NSMutableSet *set =
        [self cachedObjectSetForKey:key level:MDObjectCacherLevelHigh] ?:
        [self cachedObjectSetForKey:key level:MDObjectCacherLevelDefault] ?:
        [self cachedObjectSetForKey:key level:MDObjectCacherLevelLow] ?:
        nil;
        if (set) {
            id res = [set anyObject];
            if (res) {
                [set removeObject:res];
            }
            return res;
        }
        return nil;
    }
}

+ (void)cacheObject:(id)object forKey:(NSString *)key cacheLevel:(MDObjectCacherLevel)level; {
    if (!object ) {
        return;
    }
    @synchronized (self) {
        NSMutableSet *set = [self cachedObjectSetForKey:key level:level];
        if (set.count < [self sharedInstance].capacity) {
            [set addObject:object];
        }
    }
}

@end
