//
//  NSSet+MDTask.m
//  MDTools
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSSet+MDTask.h"

@implementation NSSet (MDTask)


- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDSetObjectTaskBlock _Nonnull)objectTask {
    return [self md_taskGroupWithObjectTask:objectTask
                            taskIdForObject:NULL];
}
- (MDTaskGroup *_Nullable)md_taskGroupWithObjectTask:(MDSetObjectTaskBlock _Nonnull)objectTask
                                     taskIdForObject:(MDSetTaskIdForObject _Nullable)taskIdForObject {
    MDTaskGroup *taskGroup = [MDTaskGroup taskGroup];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        [taskGroup addTaskBlock:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
            objectTask(task, finish, obj);
        }
                         taskId:taskIdForObject ? taskIdForObject(obj) : nil];
    }];
    return taskGroup;
}

- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDSetIdxObjectTaskBlock _Nonnull)objectTask {
    return [self md_taskListWithObjectTask:objectTask
                        taskIdForIdxObject:NULL];
}
- (MDTaskList *_Nonnull)md_taskListWithObjectTask:(MDSetIdxObjectTaskBlock _Nonnull)objectTask
                               taskIdForIdxObject:(MDSetTaskIdForIdxObject _Nullable)taskIdForIdxObject {
    NSArray *allObjects = self.allObjects;
    
    MDTaskList *taskList = [MDTaskList taskList];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        [taskList addTaskBlock:^(MDTask *task, MDTaskInputProxy inputProxy, MDTaskFinish finish) {
            objectTask(task, finish, allObjects[idx], idx);
        }
                        taskId:taskIdForIdxObject ? taskIdForIdxObject(allObjects[idx], idx) : nil];
    }
    return taskList;
}

@end
