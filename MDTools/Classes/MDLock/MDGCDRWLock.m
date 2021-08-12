//
//  MDGCDRWLock.m
//  Aspects
//
//  Created by 杨晨 on 2021/8/12.
//

#import "MDGCDRWLock.h"

@interface MDGCDRWLock ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation MDGCDRWLock

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("MDGCDRWLock", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)doWriteWithSync:(BOOL)sync task:(void (^)(void))task {
    if (sync) {
        dispatch_barrier_sync(self.queue, task);
    } else {
        dispatch_barrier_async(self.queue, task);
    }
}

- (void)doReadWithSync:(BOOL)sync task:(void (^)(void))task {
    if (sync) {
        dispatch_sync(self.queue, task);
    } else {
        dispatch_async(self.queue, task);
    }
}

@end
