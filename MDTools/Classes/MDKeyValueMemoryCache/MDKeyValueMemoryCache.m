//
//  MDKeyValueMemoryCache.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2020/7/16.
//  Copyright © 2020 allride.ai. All rights reserved.
//

#import "MDKeyValueMemoryCache.h"

@interface MDKeyValueMemoryCacheNode ()

@property (nonatomic, strong) MDKeyValueMemoryCacheNode *next;
@property (nonatomic, weak) MDKeyValueMemoryCacheNode *prior;

@property (nonatomic, strong) id object;

@end

@implementation MDKeyValueMemoryCacheNode

- (void)dealloc {
    NSLog(@"dealloc:%@", self.object);
}

@end



@interface MDKeyValueMemoryCache ()

@property (nonatomic, strong) NSMapTable <id, MDKeyValueMemoryCacheNode *> *map;
@property (nonatomic, strong) MDKeyValueMemoryCacheNode *head;
@property (nonatomic, weak) MDKeyValueMemoryCacheNode *tail;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation MDKeyValueMemoryCache

- (NSMapTable *)map {
    if (!_map) {
        _map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _map;
}

- (void)cacheObject:(id)object forKey:(id)key {
    @synchronized (self) {
        @autoreleasepool {
            if (self.count == 0) {
                self.tail = self.head = [[MDKeyValueMemoryCacheNode alloc] init];
                self.head.object = object;
                [self.map setObject:self.head forKey:key];
                self.count = 1;
                return;
            }
            MDKeyValueMemoryCacheNode *theNode = [self.map objectForKey:key];
            if (theNode && self.count == 1) {
                theNode.object = object;
                return;
            }
            if (theNode == self.tail) {
                theNode.object = object;
                self.tail = self.tail.prior;
                self.tail.next = nil;
                theNode.prior = nil;
                theNode.next = self.head;
                self.head.prior = theNode;
                self.head = theNode;
                return;
            }
            if (theNode == self.head) {
                theNode.object = object;
                return;
            }
            if (theNode) {
                theNode.object = object;
                theNode.prior.next = theNode.next;
                theNode.next.prior = theNode.prior;
                theNode.prior = nil;
                theNode.next = self.head;
                self.head.prior = theNode;
                self.head = theNode;
                return;
            }
            MDKeyValueMemoryCacheNode *node = [[MDKeyValueMemoryCacheNode alloc] init];
            node.object = object;
            node.next = self.head;
            self.head.prior = node;
            self.head = node;
            [self.map setObject:node forKey:key];
            self.count++;
        }
    }
}

- (id)getObjectForKey:(id)key {
    @synchronized (self) {
        return [self.map objectForKey:key].object;
    }
}

- (void)releaseWithPercent:(float)percent {
    @synchronized (self) {
        int i;
        for (i = 0; i < self.count * percent; i++) {
            @autoreleasepool {
                if (self.tail == self.head) {
                    self.tail = self.head = nil;
                    self.count = 0;
                    return;
                }
                self.tail = self.tail.prior;
                self.tail.next.prior = nil;
                self.tail.next = nil;
            }
        }
        self.count -= i;
    }
}

- (NSString *)description {
    NSMutableString *string = [super description].mutableCopy;
    [string appendString:@"\n"];
    [string appendFormat:@"Count: %lu\n", (unsigned long)self.count];
    MDKeyValueMemoryCacheNode *tmp = self.head;
    NSUInteger index = 0;
    while (tmp) {
        [string appendFormat:@"%ld:\t%@\n", index, tmp.object];
        index++;
        tmp = tmp.next;
    }
    return string.copy;
}

@end
