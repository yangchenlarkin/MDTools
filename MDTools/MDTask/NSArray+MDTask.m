//
//  NSArray+MDTask.m
//  Mobi
//
//  Created by Larkin Yang on 2017/9/21.
//  Copyright © 2017年 BTCC. All rights reserved.
//

#import "NSArray+MDTask.h"

@implementation NSArray (MDTask)

- (MDTaskGroup *)lt_taskGroupWithObjectTask:(MArrayObjectTaskBlock)objectTask {
    MDTaskGroup *taskGroup = [MDTaskGroup taskGroup];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [taskGroup addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, obj, idx);
        }];
    }];
    return taskGroup;
}

- (MDTaskList *)lt_taskListWithObjectTask:(MArrayObjectTaskBlock)objectTask {
    MDTaskList *taskList = [MDTaskList taskList];
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        [taskList addTaskBlock:^(MDTask *task, MDTaskFinish finish) {
            objectTask(task, finish, self[idx], idx);
        }];
    }
    return taskList;
}

@end
