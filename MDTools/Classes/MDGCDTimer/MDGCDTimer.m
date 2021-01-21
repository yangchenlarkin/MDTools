//
//  MDGCDTimer.m
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/4.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import "MDGCDTimer.h"
#import "MDCommonDefines.h"
#import <objc/runtime.h>

@implementation MDGCDTimer
__SHARED_INSTANCE__(MDGCDTimer)

+ (NSMutableDictionary *)timersFromContainer:(id)container {
    NSMutableDictionary *timers = objc_getAssociatedObject(container, "__MDGCDTimer__kTimers__");
    if (!timers) {
        timers = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(container, "__MDGCDTimer__kTimers__", timers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return timers;
}

+ (NSString *)addTimer:(NSString *)timerID
           toContainer:(id)container
                 queue:(dispatch_queue_t)queue
              duration:(NSTimeInterval)duration
           immediately:(BOOL)immediately
                 block:(void (^)(NSString *timerID))block {
    if (!block) {
        return nil;
    }
    if (duration == 0) {
        return nil;
    }
    if (!container) {
        container = [self sharedInstance];
    }
    if (!timerID) {
        timerID = [@([[NSDate date] timeIntervalSince1970]) stringValue];
        timerID = [NSString stringWithFormat:@"%@-%d", timerID, arc4random()];
    }
    
    if (!queue) {
        queue = dispatch_get_main_queue();
    }
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = immediately ? DISPATCH_TIME_NOW : dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, startTime, duration * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        block(timerID);
    });
    
    dispatch_resume(timer);
    
    NSMutableDictionary *timers = [self timersFromContainer:container];
    if (timers[timerID]) {
        dispatch_source_cancel((timers[timerID]));
    }
    timers[timerID] = (timer);
    
    return timerID;
}

+ (NSString *)cancelTimer:(NSString *)timerID
            fromContainer:(id _Nullable)container {
    if (!container) {
        container = [self sharedInstance];
    }
    NSMutableDictionary *timers = [self timersFromContainer:container];
    if (timers[timerID]) {
        dispatch_source_cancel((timers[timerID]));
        return timerID;
    }
    return nil;
}

@end
