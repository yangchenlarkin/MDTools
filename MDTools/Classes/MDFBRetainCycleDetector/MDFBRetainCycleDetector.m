//
//  MDFBRetainCycleDetector.c
//  iOS-Common-Demo
//
//  Created by 杨晨 on 2019/7/4.
//  Copyright © 2019 allride.ai. All rights reserved.
//

#include "MDFBRetainCycleDetector.h"

#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#import <FBAllocationTracker/FBAllocationTrackerManager.h>
#import <FBAllocationTracker/FBAllocationTrackerSummary.h>

void MDFBRetainCycleDetectorFind(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_BACKGROUND), ^{
        @autoreleasepool {
            NSMutableArray *filters = @[
                                        FBFilterBlockWithObjectIvarRelation([UIView class], @"_subviewCache"),
                                        ].mutableCopy;
            
            // Configuration object can describe filters as well as some options
            FBObjectGraphConfiguration *configuration =
            [[FBObjectGraphConfiguration alloc] initWithFilterBlocks:filters
                                                 shouldInspectTimers:YES];
            FBRetainCycleDetector *detector = [[FBRetainCycleDetector alloc] initWithConfiguration:configuration];
            
            NSMutableArray *classes = [NSMutableArray arrayWithCapacity:0];
            for (FBAllocationTrackerSummary *summary in [FBAllocationTrackerManager sharedManager].currentAllocationSummary) {
                [classes addObject:NSClassFromString(summary.className)];
            }
            NSArray *instances = [[FBAllocationTrackerManager sharedManager] instancesOfClasses:classes];
            for (id object in instances) {
                [detector addCandidate:object];
            }
            NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:100];
            NSLog(@"!!!!!!!retainCycles:\n%@", retainCycles);
        }
        MDFBRetainCycleDetectorFind();
    });
}

void MDFBRetainCycleDetectorBegin() {
    MDFBRetainCycleDetectorFind();
}
