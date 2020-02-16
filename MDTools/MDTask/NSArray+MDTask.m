//
//  NSArray+MDTask.m
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSArray+MDTask.h"

@implementation NSArray (MDTask)

- (MDTaskGroup *)md_taskGroupWithObjectTask:(MDArrayObjectTaskBlock)objectTask {
    return [self md_taskGroupWithObjectTask:objectTask
                             taskIdForIndex:NULL];
}

- (MDTaskGroup *)md_taskGroupWithObjectTask:(MDArrayObjectTaskBlock)objectTask
                             taskIdForIndex:(MDArrayObjectTaskId)taskIdForIndex {
    MDTaskGroup *taskGroup = [MDTaskGroup taskGroup];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [taskGroup addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, obj, idx);
        }
                         taskId:taskIdForIndex ? taskIdForIndex(obj, idx) : nil];
    }];
    return taskGroup;
}

- (MDTaskList *)md_taskListWithObjectTask:(MDArrayObjectTaskBlock)objectTask {
    return [self md_taskListWithObjectTask:objectTask
                            taskIdForIndex:NULL];
}

- (MDTaskList *)md_taskListWithObjectTask:(MDArrayObjectTaskBlock)objectTask
                           taskIdForIndex:(MDArrayObjectTaskId)taskIdForIndex {
    MDTaskList *taskList = [MDTaskList taskList];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        [taskList addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, self[idx], idx);
        }
                        taskId:taskIdForIndex ? taskIdForIndex(self[idx], idx) : nil];
    }
    return taskList;
}

@end
