//
//  MDGCDTimer.h
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/4.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDGCDTimer : NSObject

+ (NSString *)addTimer:(NSString * _Nullable)timerID
           toContainer:(id _Nullable)container
                 queue:(dispatch_queue_t _Nullable)queue
              duration:(NSTimeInterval)duration
           immediately:(BOOL)immediately
                 block:(void (^)(NSString *timerID))block;

+ (NSString *)cancelTimer:(NSString *)timerID
            fromContainer:(id _Nullable)container;

@end

NS_ASSUME_NONNULL_END
