//
//  MDListener.m
//  mobi-app
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
    [self.listeners addObject:listener];
}

- (void)removeListener:(NSObject *)listener {
    [self.listeners removeObject:listener];
}

- (void)performAction:(MDListenerAction)action {
    for (id object in self.listeners) {
        if (self.listeners) {
            action(object);
        }
    }
}

- (NSUInteger)listenerCount {
    return self.listeners.count;
}

@end
