//
//  MDListener.m
//  MDTools
//
//  Created by Larkin Yang on 2017/5/25.
//  Copyright © 2017年 Larkin Yang. All rights reserved.
//

#import "MDListener.h"

@interface MDListener ()

@property (nonatomic, strong) NSHashTable *listeners;

@end

@implementation MDListener

- (NSHashTable *)listeners {
    if (!_listeners) {
        _listeners = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:0];
    }
    return _listeners;
}

- (void)addListener:(NSObject *)listener {
    if (!listener) {
        return;
    }
    @synchronized (self) {
        [self.listeners addObject:listener];
    }
}

- (void)removeListener:(NSObject *)listener {
    @synchronized (self) {
        [self.listeners removeObject:listener];
    }
}

- (void)performAction:(MDListenerAction)action {
    NSArray *allListeners = nil;
    @synchronized (self) {
         allListeners = self.listeners.allObjects.copy;
    }
    for (id object in allListeners) {
        if (action) {
            action(object);
        }
    }
}

- (NSUInteger)listenerCount {
    return self.listeners.allObjects.count;
}

@end
